# vagrant-aws-dns

[![Gem Version](https://badge.fury.io/rb/vagrant-aws-dns.svg)](https://badge.fury.io/rb/vagrant-aws-dns) [![Dependency Status](https://gemnasium.com/nasskach/vagrant-aws-dns.svg)](https://gemnasium.com/nasskach/vagrant-aws-dns) [![Code Climate](https://codeclimate.com/github/nasskach/vagrant-aws-dns/badges/gpa.svg)](https://codeclimate.com/github/nasskach/vagrant-aws-dns)

`vagrant-aws-dns` is a Vagrant plugin that allows you to set up route53 records for instances created using vagrant-aws provider.

## Behaviors

* Add/update route53 records on machine up.
* Remove associated route53 records on machine halt/destroy.

## Release notes
#### 0.2.3

- Downgrade bundler version due to some dependencies problems.

#### 0.2.2

- Upgrade aws-sdk to 2.3.9.
- Upgrade bundler to 1.12.
- Upgrade rake to 11.1.

#### 0.2.1

- [BUGFIX] hard-coded AWS region ([#1](https://github.com/nasskach/vagrant-aws-dns/issues/1)) - Thanks [hoopesj](https://github.com/hoopesj) for the reporting.
- Upgrade aws-sdk to 2.2.14.

#### 0.2.0 

- Adding multiple HOSTED_ZONE_ID support.
- Upgrade aws-sdk to 2.2.9.
 
## Installation

    $ vagrant plugin install vagrant-aws-dns

## Usage

### Configuration example

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = "YOUR KEY"
    aws.secret_access_key = "YOUR SECRET KEY"
    aws.session_token = "SESSION TOKEN"
    aws.keypair_name = "KEYPAIR NAME"

    aws.ami = "ami-7747d01e"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "PATH TO YOUR PRIVATE KEY"
    
    override.dns.record_sets = [%w(HOSTED_ZONE_ID_1 subdomain.domain1.com A 4.3.2.1), %w(HOSTED_ZONE_ID_2 subdomain.domain2.com A)]
  end
```

### record_sets

`record_sets` is an array of record sets that are also represented as arrays. Below are some examples:

* `%w(HOSTED_ZONE_ID subdomain.domain.com A)` - This will set a record of type `subdomain.domain.com. A <public_ip>`, the `<public_ip>` is auto detected.
* `%w(HOSTED_ZONE_ID subdomain.domain.com A 4.3.2.1)` - This will set a record of type `subdomain.domain.com. A 4.3.2.1`.
* `%w(HOSTED_ZONE_ID subdomain.domain.com CNAME domain2.com)` - This will set a record of type `subdomain.domain1.com. CNAME domain2.com.`.

The ip may be omitted in which case the correct ip (private/public) will be chosen based on the type of the HOSTED_ZONE_ID.
If the record type is CNAME and the value is not provided, the private/public AWS DNS name will be used instead. 

## FAQ

* Why this plugin is not named `vagrant-aws-route53` ?

> Unfortunately, that name was already taken by another plugin of the same kind.


* So why develop a new one?
 
> There are several reasons for this: use of new AWS SDK, support of multiple records, support of deleting records on machine halt
  or destroy.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nasskach/vagrant-aws-dns.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgments

I want to thank my employer `atHome Group S.A - REA Group` for giving me the opportunity to share this work with the open source community.
