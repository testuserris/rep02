#base image for powershell
FROM mcr.microsoft.com/powershell:7.3-ubuntu-20.04

#install curl
RUN apt-get update && apt-get install -y \
curl \
wget

ENV PATH=$PATH:/home
#install Azure-cli
RUN apt-get install ca-certificates curl apt-transport-https lsb-release expect gnupg -y
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor |  tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list 
RUN apt-get update && apt-get install azure-cli
RUN az upgrade -y
RUN az aks install-cli --install-location /home/kubectl

#Copy Optix Scripts

ADD https://staging-optix.s3.eu-central-1.amazonaws.com/on-boarding-scripts/azure/create-azure-app.ps1 /create-azure-app.ps1
ADD https://staging-optix.s3.eu-central-1.amazonaws.com/on-boarding-scripts/azure/delete-azure-app.ps1 /delete-azure-app.ps1
ADD https://staging-optix.s3.eu-central-1.amazonaws.com/on-boarding-scripts/azure/onboard-aks.ps1 /onboard-aks.ps1
ADD https://staging-optix.s3.eu-central-1.amazonaws.com/on-boarding-scripts/azure/remove-aks.ps1 /remove-aks.ps1

CMD /bin/bash 



