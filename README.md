# Ansible - ASA Password Reset

This is an Ansible playbook which will reset the user passwords for the specified list of users on a Cisco ASA Firewall. A primary use case for this might be when you have hundreds of local accounts defined, and you need to rotate all their passwords periodically.

There is also a Dockerfile which builds this into a Docker image. This is the easiest route to getting started, and is documented below.

## Getting Started

Check out the variables and their default values to understand what can be overridden. These are specified in [ansible/roles/asa_password_reset/defaults/main.yml](ansible/roles/asa_password_reset/defaults/main.yml)

You will notice that `asa_password_reset_user_accounts` is an empty array. This variable defines a list of user accounts to reset the passwords for. You can override that (and other) variable(s) by creating a YAML file locally and setting a new value there, for example:
```yaml
asa_password_reset_user_accounts:
  - team3.user1
  - team3.user2
  - team3.user3
```
This can then be passed to the Docker image and run as follows:
```bash
docker run --rm -it \
  -v "$PWD/users.yml:/extra-vars.yml" \
  -v "$PWD/output/:/output/" \
  asa-password-reset
```

You will see that I've called my YAML file `users.yml`, and I've mapped it to the Docker image in the path `/extra-vars.yml`. I've also mapped an local directory `./output` to the directory `/output` inside the container. If the `./output` directory doesn't exist it will be created. The commands that are run against the remote ASA firewall will be recorded in that directory in the file `./output/commands.txt`, effectively giving you a user and password list like this:

<pre>$ cat ./output/commands.txt</pre>
```
configure terminal
username team3.user1 password MmXR8STa35uF
username team3.user2 password HmCHWE5KZ2rp
username team3.user3 password 2QPFcnZkFQZY
write memory
```

### Running the container

The container has been set to output in verbose mode, passing `-v` to `ansible-playbook`. You'll therefore get more output on screen than usual. However, you will be prompted for 4 pieces of information, as follows:

* **What's the FQDN or IP address of the ASA firewall?:**  
This can be an IP address or a Fully Qualified Domain Name, and is the address that you connect to when SSH'ing the firewall.

* **What's your SSH username?:**  
This is your login user that you can connect over to the network to the ASA firewall using.

* **What's your SSH password?:**  
This is the first password you use to log in. This will usually get you to User EXEC mode, an under-privileged level on the firewall.

* **What's your enable password?:**  
This is the second password you use, which gets you to Privileged EXEC mode, giving you full all the available commands. If in doubt, this will likely be the SSH password again.

After entering those, and assuming everything went smoothly, Ansible will start resetting your passwords. You can collect the usernames and passwords then from the file `./output/commands.txt`

## Built With

* [Ansibe](https://docs.ansible.com/) - Ansible is Simple IT Automation

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/miff2000/asa-password-reset/tags). 

## Authors

* **Matt Calvert** - *Initial work* - [miff2000](https://github.com/miff2000)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Thanks to Billie Thompson [PurpleBooth](https://gist.github.com/PurpleBooth) for the template Markdown files for contributing, etc.
