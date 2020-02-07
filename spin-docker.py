#!/usr/bin/env python3
import dotenv
import os
import subprocess
import click
from createPemFiles import SelfSignedCertificate, IsCertExist


print_debug = 'No'


def print_info(message):
    global print_debug
    if print_debug == 'yes':
        print("--- python debug ---> ", message)


def PrepareEnvironmentVars(environmentName, action):
    # Reads the .env file from the repository
    # Returns an array with all the env vars, inclduing modificatoins per env
    devwebsport = 'DEV_WEB_GUEST_SECURE_PORT'
    dotenv.load_dotenv()
    envArray = os.environ.copy()
    envArray['RUN_BY_PYTHON'] = 'yes'
    envArray['ENVIRONMENT'] = environmentName
    envArray['HOMEPATH'] = '/home'
    if (environmentName == 'dev'):
        envArray['WEB_HOST_PORT'] = envArray['DEV_WEB_HOST_PORT']
        envArray['WEB_GUEST_PORT'] = envArray['DEV_WEB_GUEST_PORT']
        envArray['WEB_HOST_SECURE_PORT'] = envArray['DEV_WEB_HOST_SECURE_PORT']
        envArray['WEB_GUEST_SECURE_PORT'] = envArray[devwebsport]
    if(environmentName == 'stage'):
        envArray['AWS_SECRET_ACCESS_KEY'] = envArray['STAGE_MEETUP_SECRET']
        envArray['AWS_ACCESS_KEY_ID'] = envArray['STAGE_MEETUP_KEY']
        envArray['TF_VAR_zone_id']=envArray['STAGE_HOSTED_ZONE_ID']
        envArray['TF_VAR_key_name']= envArray['STAGE_KEYPAIR_NAME']
        envArray['ANSIBLE_HOST_KEY_CHECKING']= 'False'
    return envArray


@click.command()
@click.option("-e", "--environment", required=False, default="dev",
                    type=click.Choice(["dev", "prod", "stage"]))
@click.option("-a", "--action", required=False, default="up",
                    type=click.Choice(["up", "destroy"]))
@click.option("-d", "--debug", required=False, default="no",
                    type=click.Choice(["yes", "no"]))
@click.option("-m", "--method", required=False, default="terraform",
                    type=click.Choice(["terraform", "kubernetes"]))
def main(environment, action, debug):
    machineName = environment
    envVars = machineName
    envVars = PrepareEnvironmentVars(envVars, action)
    if not (IsCertExist()):
        SelfSignedCertificate()
    if(action == "up"):
        command = "docker-compose up -d"
        vault_command = "j2 vault/config.hcl.j2 -o vault/config/config.hcl"
        vault_copy = "docker cp vault/config/config.hcl vault:/vault/config"
        subprocess.call(command, env=envVars, shell=True)
        subprocess.call(vault_command, env=envVars, shell=True)
        subprocess.call(vault_copy, env=envVars, shell=True)
    if(action == "destroy"):
        command = "docker-compose down -v --rmi all --remove-orphans"
        subprocess.Popen(command, env=envVars, shell=True)

class stager:
    def __init__(self, action, method):
        self.envvars=PrepareEnvironmentVars('stage', action)
        self.method = method
    def raise_stage_env(self):
        if self.method == 'terraform':
            return self.raiseterraform
    def raiseterraform(self):
        subprocess.call('./terrabash',env=self.envvars,shell=True)




if __name__ == '__main__':
    main()
