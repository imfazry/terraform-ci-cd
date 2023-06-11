#!/bin/bash

apt-get update
apt-get install -y ansible

cat <<EOF > /tmp/jenkins-playbook.yml
- name: Install Jenkins
  hosts: localhost
  become: true
  become_user: root

  tasks:
    - name: Add Jenkins apt repository key
      apt_key:
        url: https://pkg.jenkins.io/debian-stable/jenkins.io.key
        state: present

    - name: Add Jenkins apt repository
      apt_repository:
        repo: deb https://pkg.jenkins.io/debian-stable binary/
        state: present

    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Java
      apt:
        name: openjdk-11-jdk
        state: present

    - name: Install Jenkins
      apt:
        name: jenkins
        state: present
        
    - name: Start Jenkins service
      service:
        name: jenkins
        state: started
EOF

ansible-playbook /tmp/jenkins-playbook.yml