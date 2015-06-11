# Cloud9IDE ssh workspace in a coreos container

## Setup

In your Cloud9IDE dashboard, create a new project and select the ssh workspace type.
You will be presented with a modal dialog with a ssh public key pre-populated.
Chose a workspace name and enter the hostname of your CoreOS host.

**Make sure you input port `2222` for the ssh connection as the generated container will listen on that port on the CoreOS host network stack.** 

Copy the public key from the modal dialog and run the setup script that will prompt you for this key.

```
./setup.sh
```

This will build a docker image called `cloud9ide`.

To start the container, run:

```
./start.sh
```

Now you are ready to hit the `test` button on the Cloud9IDE modal and complete the setup if the test succeeds.


