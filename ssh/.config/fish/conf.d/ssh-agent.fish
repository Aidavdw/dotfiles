# On non-systemd systems, you might have to manually start the ssh agent.
set -gx SSH_AUTH_SOCK ~/.ssh/agent.sock
if not test -S $SSH_AUTH_SOCK
	ssh-agent -a $SSH_AUTH_SOCK > /dev/null
end
