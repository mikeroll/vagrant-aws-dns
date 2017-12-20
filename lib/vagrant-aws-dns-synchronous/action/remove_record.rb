require_relative 'base'


module VagrantPlugins
  module AwsDns
    module Action
      class RemoveRecord < Base

        def call(env)
          super env do |hosted_zone_id, record, type, value|
            @aws.remove_record(hosted_zone_id, record, type, value)
            @machine.ui.info("Removing dns record #{record}.")
          end
        end

      end
    end
  end
end
