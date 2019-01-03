class cron {

cron {shutdown:
command => "/sbin/shutdown +10 'Server about to shutdown - Daily Schedule'",
user => root,
hour => 23,
minute => 50
}
}
