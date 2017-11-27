require 'vagrant'


module VagrantPlugins
  module AwsDns
    class Plugin < Vagrant.plugin('2')
      name 'aws-dns'

      description <<-DESC
        A Vagrant plugin that allows you to setup route53 records.
      DESC

      config :dns do
        require_relative 'config'
        Config
      end

      action_hook :add_record, :machine_action_up do |hook|
        require_relative 'action/add_record'
        hook.after VagrantPlugins::AWS::Action::RunInstance,   VagrantPlugins::AwsDns::Action::AddRecord
        hook.after VagrantPlugins::AWS::Action::StartInstance, VagrantPlugins::AwsDns::Action::AddRecord
      end

      action_hook :remove_record, :machine_action_halt do |hook|
        require_relative 'action/remove_record'
        hook.after VagrantPlugins::AWS::Action::StopInstance,      VagrantPlugins::AwsDns::Action::RemoveRecord
        hook.after VagrantPlugins::AWS::Action::TerminateInstance, VagrantPlugins::AwsDns::Action::RemoveRecord
      end

      action_hook :remove_record, :machine_action_destroy do |hook|
        require_relative 'action/remove_record'
        hook.before VagrantPlugins::AWS::Action::StopInstance,      VagrantPlugins::AwsDns::Action::RemoveRecord
        hook.before VagrantPlugins::AWS::Action::TerminateInstance, VagrantPlugins::AwsDns::Action::RemoveRecord
      end

      action_hook :add_record, :machine_action_reload do |hook|
        require_relative 'action/remove_record'
        hook.after VagrantPlugins::AWS::Action::StopInstance,      VagrantPlugins::AwsDns::Action::RemoveRecord
        hook.after VagrantPlugins::AWS::Action::TerminateInstance, VagrantPlugins::AwsDns::Action::RemoveRecord

        require_relative 'action/add_record'
        hook.after VagrantPlugins::AWS::Action::RunInstance,   VagrantPlugins::AwsDns::Action::AddRecord
        hook.after VagrantPlugins::AWS::Action::StartInstance, VagrantPlugins::AwsDns::Action::AddRecord
      end

    end
  end
end