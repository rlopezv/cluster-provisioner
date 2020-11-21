#######################################
# Just print a message
# Globals:
#   None
# Arguments:
#   Text to be printed
# Returns:
#   None
#######################################
msg() {
  echo "===== ${*} ====="
}


echo_do() {
  local tmp_file
  local ret_code

  [[ -n "${VERBOSE}" ]] && echo "    $*"
  tmp_file=$(mktemp /var/tmp/cmd_XXXXX.log)
  eval "$@" > "${tmp_file}" 2>&1
  ret_code=$?
  if [[ ${ret_code} -ne 0 ]]; then
    [[ -z "${VERBOSE}" ]] && echo "$@"
    echo "Returned a non-zero code: ${ret_code}" >&2
    echo "Last output lines:" >&2
    tail -5 "${tmp_file}" >&2
    echo "See ${tmp_file} for details" >&2
    exit ${ret_code}
  fi
  rm "${tmp_file}"
}

passwordless_ssh() {
  msg "Allow passwordless ssh between VMs"
  # Generate common key
  if [[ ! -f /vagrant/id_rsa ]]; then
    msg "Generating shared SSH keypair"
    echo_do ssh-keygen -t rsa -f /vagrant/id_rsa -q -N "''"
  fi
  # Install private key
  echo_do mkdir /root/.ssh
  echo_do cp /vagrant/id_rsa /root/.ssh/
  # Authorise passwordless ssh
  echo_do cp /vagrant/id_rsa.pub /root/.ssh/authorized_keys
  echo_do eval "cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
  # Don't do host checking
  cat > ~/.ssh/config <<-EOF
	Host operator* master* worker* 192.168.99.*
	  StrictHostKeyChecking no
	  UserKnownHostsFile /dev/null
	  LogLevel QUIET
	EOF
  # Set permissions
  echo_do chmod 0700 /root/.ssh
  echo_do chmod 0600 /root/.ssh/authorized_keys /root/.ssh/id_rsa
  # Last node removes the key
  if [[ ${OPERATOR} == 1 ]]; then
    msg "Removing the shared SSH keypair"
    echo_do rm /vagrant/id_rsa /vagrant/id_rsa.pub
  fi
}

#######################################
# Main
#######################################
main () {
#   parse_args "$@"
#   setup_networking
#   setup_repos
#   requirements
#   install_packages
  passwordless_ssh
#   # All nodes are up, orchestrate installation
#   if [[ ${OPERATOR} == 1 ]]; then
#     certificates
#     bootstrap_olcne
#     deploy_kubernetes
#     deploy_modules
#     fixups
#     ready
#   fi
}

main "$@"