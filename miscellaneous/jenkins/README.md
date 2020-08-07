## Jenkins

### Installation
Run install.sh it will instll default-jdk-headless and jenkins

Access is possibly via http://SERVER_IP:8080

### SetUp
for Setting up the building it is recommended to install maven, git and github
also add MAVEN_HOME to environemnnts.
Add JAVA_HOME and MAVEN_HOME in the configuration page on jenkins

java home directory would be /usr (on 08.01.2020)
maven can be installed with sudo apt-get install -y maven.
Directory is under /usr/share/maven

### Example Maven Build

Select Create new item.
Select the name and Free Style Project.
Add Description.
Add the GitHub URL.
Add Build Action--> Maven Goals.
Select Maven-Version which is configured by you.
Add goals "clean package" which cleans the environment and test, compiles and packages the software

### Example Dotnet build
Install dotnet with installdotnet.sh File



### Manual build
In the Project Click Build now


### Periodic build
In the configure project page select Poll SCM in Build trigger.
the timeplan is in the CRON format
* * * * *
The five points are
* minute (0-59)
* hour (0-23)
* day of month (1-31)
* month (1-12)
* day of week (0-6) (Sunday = 0)

Example (every day at midnight):
0 0 * * *


## Pipelining
For Pipeline create a project with the pipeline configuration
install Plugin Pipeline Maven Integration if Pipeline is used for maven projects

Add a Jenkinsfile to Repo to configure pipeline use the provided script

### AWS in Jenkins
For AWS CLi Usage install CLI on server and add the Credentials to the Credential file for AWS CLi


### Docker in Jenkins
Install docker with sudo apt-get install -y docker.io and start the service
Add Jenkins as docker user with this command: sudo usermod -a -G docker jenkins
Now it is possible to use docker commands in pipeline
