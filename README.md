Client-server setup for IPython-Notebook based courses
======================================================

Rationale
---------

Quickstart
----------

1. Check that your computing infrastructure fulfils the [Requirements](#requirements).

2. Create one account on each computer-lab [client](#client-m),
   exclusively to be used for the course. The usernames should be
   different on each machine and will correspond to one (or a team of
   two) participants. These accounts need passwords.
   
3. Log into an [administration account](#admin-acc) on the [server](#server).

4. Clone the repository on github, e.g.:   

	``` {.bash}
	git clone https://github.com/C2SM/ipython-workshop-setup.git ./setup
    ```

	or click the "Download ZIP" - button on the
    [GitHub page](https://github.com/C2SM/ipython-workshop-setup) and
    uncompress.

5. Modify the file `clients-template.txt` and save it as `clients.txt`. The format of the file is:

	+ The first line contains `instructor_un@server`, where
      "`instructor_un`" is a username for a special ("instructor")
      account on the [server](#server), and "`server`" stands for its
      FQDN, e.g., "`climserv.dept.university.ch`".
    + From the second line on, the first row contains
      `participantX@clientX`, where "`participantX`" stands for a
      participant's username and "`clientX`" stands for the
      corresponding [client-machine](#client-m),
      e.g. "`part05@client05.mylab.mydomain.tld`".
	+ The second row contains the corresponding passwords (of the client accounts).
	+ The third row contains "`participantX@server`", indicating the
      accounts on the [server](#server), which correspond to the
      client accounts. **These accounts will be generated automatically!**.
	+ Include participants who bring their own laptop by writing
	  *personal_laptop* in the first column, an arbitrary dummy_password
	  in the second one (not used) and an ordinary client account
	  descriptor in the third column.
	+ **Fields (columns) are seperated by exactly one space!**
	+ You can include a line that associates the instructor-account on
      the [server](#server) with a client-machine account. This way you (as
      instructor) will have a setup identical to the participants. Do
      this by adding the appropriate line anywhere below the first
      line.

6. Run `mk_server_accounts.sh`. This will create the instructor- and
   participant-accounts on the server, install a
   [*virtualenv*](https://virtualenv.pypa.io/en/latest/) in the
   instructor-account, and install the necessary packages in this
   *virtualenv* ("necessary packages" as defined in
   `requirements.txt`).

7. Run `cpkeys.sh`. This will create ssh key pairs on the clients, and
   copy the public key to `.ssh/authorized_keys` in the respective
   accounts on [server](#server).

8. Run `clientprep.sh`. This will customize the `startup_template.txt`
   and copy it as `startup.sh` into each client's $HOME.

9. Test the installation: Log into a [client](#client-m)-account and
   run `./startup.sh`. this should start an Ipython-Notebook instance
   in the *virtualenv* but on the corresponding
   [server](#server)-participant-account, do the ssh-forwarding thing,
   and - after some seconds - start Firefox pointed at the
   Notebook. Try simultaneously with different client accounts.



<a name="requirements"></a>Requirements
---------------------------------------
TODO


Nomenclature
------------

<a name="client-m"></a>**client-machine**: A machine used by one or
two participants. Might be a computer-lab machine or a personal
laptop. Identified by FQDN, e.g., `client05.mylab.mydomain.tld`.

<a name="admin-acc"></a>**administration account**: An account that
lets you `sudo` to root-privileges non-interactively.

<a name="server"></a>**server**: A machine on which the Python
interpreter, Ipython, Notebook, and a virtual environment responding
to the necessities of the teaching material are installed. All
Notebook instances are run on this machine.
