require 'vagrant'


module VagrantPlugins
  module AwsDns
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :hosted_zone_id
      attr_accessor :record_sets

      def initialize
        @hosted_zone_id = UNSET_VALUE
        @record_sets     = UNSET_VALUE
      end

      def finalize!
        @hosted_zone_id = nil if @hosted_zone_id == UNSET_VALUE
        @record_sets = nil if @record_sets == UNSET_VALUE
      end

      def validate(machine)
        finalize!

        errors = _detected_errors

        { 'AwsDns' => errors }
      end
    end
  end
end