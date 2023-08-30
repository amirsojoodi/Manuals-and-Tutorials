# Install Nexus Repository Manager

Get all the files and edit the *config.sh* files. I'm sure you are smart enough to use the script! Edit the variables and follow the instructions. You can execute script commands seperately on your own.

## Upgrading

Become familiar with the basic directory structure of a [Nexus Repository Manager installation](https://support.sonatype.com/hc/en-us/articles/231742807). You are encouraged to stick with the standard installation layout to make future upgrades as simple as possible.

You will have to determine your existing installation data directory location. Record this value for later use.

## Download the Latest Installer Archive

Download the latest installer archive for your platform from the official downloads. Extract the newest downloaded distribution archive using the standard approach.

## Preparing the new Install

Suppose 3.14.0-04 is the new version.
Move the downloaded zip to your desired directory. (Basic place is /usr/local)

```bash
sudo cp nexus-3.14.0-04-unix.tar.gz /usr/local
sudo tar xzvf nexus-3.14.0-01-unix.tar.gz
```

Compare the `nexus-3.14.0-04/bin/nexus.vmoptions` file with your existing version.

If you have changed the default location of the Data Directory, then edit `./bin/nexus.vmoptions` and change the line `-Dkaraf.data=../sonatype-work/nexus3` to point to your existing data directory. Example: `-Dkaraf.data=/app/nexus3/data`

If you changed the default location of the temporary directory,  then edit `./bin/nexus.vmoptions` and replace the line `-Djava.io.tmpdir=../sonatype-work/nexus3/tmp` to point to your preferred temporary directory.

If you adjusted the default Java virtual machine max heap memory, then edit `./bin/nexus.vmoptions` and edit the line `-Xmx1200M` accordingly.

If you have enabled jetty HTTPS access, make sure your `etc/jetty/jetty-https.xml` SSL keystore location is still available to the new install.

If you manually adjusted any other install files under ./etc you will need to manually perform a diff between the old files and the new files and apply your changes if applicable to the new version.

Perform the Upgrade.

Ensure you have taken recent backups of the existing Data Directory and any custom blobstore locations according to our recommended practices. Because of involved Upgrade steps, downgrading a NXRM version is not supported and will almost always result in failures.If you have issues, restore from this backup instead.

Stop your existing install using the scripts under ./bin or your operating system service. Make sure it stops completely.

```bash
sudo service nexus stop
./nexus/bin/nexus stop
```

Change owner of the new directory to the your desired user:

```bash
sudo chown user:user nexus-3.14.0-04/ -R
```

Remove previous soft links and create new one and update permissions of it:

```bash
sudo rm nexus
sudo ln -s /usr/local/nexus-3.14.0-04 /usr/local/nexus
sudo chown user:user nexus -R
```

If you have configure Nexus Service, update the service as well:

```bash
sudo update-rc.d nexus defaults
```

Update user in the file `/usr/local/nexus/bin/nexus.rc`

```bash
run\_as\_user="user"
```

Start the new installation using the scripts under ./bin or adjust your operating system service to use these scripts.

```bash
./nexus start
sudo service nexus start
```

Review the log files for any possible issues and sign-in to the server to confirm things are working as expected.
