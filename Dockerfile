
# s2i-apb
FROM ansibleplaybookbundle/apb-base
MAINTAINER Ansible Playbook Bundle Community

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
LABEL io.openshift.s2i.destination=/tmp

COPY ./s2i/bin/ /usr/libexec/s2i

ENV USER_NAME=apb \
    USER_UID=1001 \
    BASE_DIR=/opt/${USER_NAME}
ENV HOME=${BASE_DIR}

USER root
RUN mkdir -p /opt/ansible/roles
RUN mkdir -p ${BASE_DIR}/actions
RUN mkdir -p /tmp/.s2i

RUN chown ${USER_NAME}:0 /opt/ansible/roles
RUN chown ${USER_NAME}:0 ${BASE_DIR}/actions
RUN chown ${USER_NAME}:0 /tmp/.s2i

USER ${USER_NAME}
RUN chmod  g+rw /opt/ansible/roles
RUN chmod  g+rw ${BASE_DIR}/actions
RUN chmod  a+rw /tmp/.s2i

ENTRYPOINT []
CMD ["usage"]
