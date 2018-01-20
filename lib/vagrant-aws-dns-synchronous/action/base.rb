require 'aws-sdk'
require_relative '../util/aws_util'


module VagrantPlugins
  module AwsDns
    module Action
      class Base

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def call(env)
          return @app.call(env) if @machine.config.dns.record_sets.nil?

          @aws = AwsDns::Util::AwsUtil.new(@machine.provider_config.access_key_id,
                                           @machine.provider_config.secret_access_key,
                                           @machine.provider_config.region)
          instance = @aws.instance_info(@machine.id)

          @machine.config.dns.record_sets.each do |record_set|
            hosted_zone_id, record, type, value = record_set
            zone_type = @aws.get_zone_type(hosted_zone_id)

            default_value = if type == 'CNAME'
              instance.public_send("#{zone_type}_dns_name")
            else
              instance.public_send("#{zone_type}_ip_address")
            end

            yield hosted_zone_id, record, type, value || default_value if block_given?
          end

          @app.call(env)
        end

      end
    end
  end
end
