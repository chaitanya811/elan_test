class role::appserver () {
contain profile::coreproducts
contain profile::mcollect
contain profile::audit
contain profile::push
contain profile::apachetomcat
}
