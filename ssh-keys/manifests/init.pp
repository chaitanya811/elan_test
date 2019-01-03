class ssh-keys{
tag 'ssh-keys'

ssh_authorized_key {'EDALLINP01.ELAN.ELANTECS.COM':
ensure => 'present',
user => 'root',
type => 'ssh-rsa',
key => hiera('ssh-keys::ssh-pubkey-edallinp01'),
}

ssh_authorized_key {'RMOTURI-LOGIN':
ensure => 'present',
user => 'root',
type => 'ssh-rsa',
key => hiera('ssh-keys::ssh-pubkey-rmoturi'),
}

ssh_authorized_key {'ELANADMIN-LOGIN':
ensure => 'present',
user => 'elanadmin',
type => 'ssh-rsa',
key => hiera('ssh-keys::ssh-pubkey-elanadmin'),
}

ssh_authorized_key {'ELANANSIBLE-LOGIN':
ensure => 'present',
user => 'elanansible',
type => 'ssh-rsa',
key => hiera('ssh-keys::ssh-pubkey-elanadmin'),
}

}
