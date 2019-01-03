#!/usr/bin/python

from subprocess import PIPE, Popen

def cmdline(command):
    process = Popen(
        args=command,
        stdout=PIPE,
        shell=True
    )
    return process.communicate()[0]

outputs = cmdline('ssh-keyscan -t rsa $(hostname -f)')

if len(outputs.strip()) == 0 :
    print "\nssh-rsa key not available at this time ..\n"
    print "ssh-rsa-key=undef"
else:
    print "ssh-rsa-key=%s" % outputs
