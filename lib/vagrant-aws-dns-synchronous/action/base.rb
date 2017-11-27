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
          public_ip = @aws.get_public_ip(@machine.id)
          private_ip = @aws.get_private_ip(@machine.id)

          @machine.config.dns.record_sets.each do |record_set|
            hosted_zone_id, record, type, value = record_set

            if @aws.is_private_zone(hosted_zone_id)
               yield hosted_zone_id, record, type, value || private_ip  if block_given?
            else
               yield hosted_zone_id, record, type, value || public_ip  if block_given?
            end
          end

          @app.call(env)
        end

      end
    end
  end
end
