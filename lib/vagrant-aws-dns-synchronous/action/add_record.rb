require_relative 'base'


module VagrantPlugins
  module AwsDns
    module Action
      class AddRecord < Base

        def call(env)
          super env do |hosted_zone_id, record, type, value|
            env[:ui].info("Configuring DNS record...")
            @aws.add_record(hosted_zone_id, record, type, value)
            env[:ui].info("Updated DNS record #{record} to point to #{value}.")
          end
        end

      end
    end
  end
end
