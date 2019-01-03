class role::infraservices inherits role::base {
contain profile::mcollect
contain profile::audit
contain profile::push
}
