#!/bin/bash
DIR1="${JENKINS_HOME}/init.groovy.d"
DIR2="${JENKINS_HOME}/casc_configs"
if [ "$(ls -A $DIR1)" ]; 
then
    echo "EFS volume ${JENKINS_HOME} already initialized"
    rm -f $REF/plugins/*
    echo "Removed any download plugins from ${REF} "
else # Execute once at container start to initate the persisten volume
    #Create EFS folders
    mkdir -p $DIR1
    mkdir -p $DIR2
    mkdir -p $REF
    mkdir -p $REF/init.groovy.d
    # Move files to EFS folders
    mv $JENKINS_TMP/plugins.txt $REF/plugins.txt
    mv $JENKINS_TMP/jenkins.yaml $JENKINS_HOME/casc_configs/jenkins.yaml
    mv $JENKINS_TMP/startup-properties.groovy $JENKINS_HOME/init.groovy.d/startup-properties.groovy
    #Install plugins  Removed the war versions check parameter
    $JENKINS_ROOT/scripts/jenkins-plugin-cli  --plugin-file $REF/plugins.txt --war $JENKINS_ROOT/bin/jenkins.war --plugin-download-directory $REF/plugins  --jenkins-version $JENKINS_VERSION   
    rm -f  $JENKINS_ROOT/scripts/jenkins-plugin-cli  $JENKINS_ROOT/bin/jenkins-plugin-manager.jar $REF/plugins.txt
    # TODO When the EFS has the permissions changed by an app to jenkins, the root user sticks. I dont know why and the jenkins user still has access to the 
    # the EFS volume. This needs to be fixed to show only Jenkins user show in the file permission 
    chown -R  1000:1000 $JENKINS_HOME
    chmod -R u+rwx,g+rwx,o-rwx  $JENKINS_HOME
    echo "EFS Volume ${JENKINS_HOME} initialization completed"
fi
#sleep 50000