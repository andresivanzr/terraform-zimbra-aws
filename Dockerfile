FROM zimbra/zm-base-os:devcore-ubuntu-20.04
RUN sudo apt install rsync -y && mkdir installer-build && cd installer-build
RUN git clone https://github.com/Zimbra/zm-build.git && cd /home/build/zm-build/ && git checkout origin/develop
RUN /home/build/zm-build/build.pl --build-no=1713 --build-ts=`date +'%Y%m%d%H%M%S'`   --build-release=JOULE --build-release-no=8.8.15   --build-release-candidate=GA --build-type=FOSS   --build-thirdparty-server=files.zimbra.com --no-interactive


