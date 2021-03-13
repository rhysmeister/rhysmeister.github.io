---
layout: post
title: ansible-vault unexpected exception on Ubuntu
date: 2019-04-09 12:06:36.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
meta:
  _edit_last: '1'
  tweetbackscheck: '1613480471'
  _sg_subscribe-to-comments: allen.lovett@hotmail.co.uk
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ansible-vault-unexpected-exception-on-ubuntu/2436/"
---
When attempting to edit an [ansible-vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) file...

```
ansible-vault edit roles/cassandra_backup/vars/test_s3_cfg.yaml
```

The following error was received...

```
ERROR! Unexpected Exception, this is probably a bug: from_buffer() cannot return the address of the raw string within a str or unicode or bytearray object
```

Encountered on this version of Ubuntu...

```
Linux xxxxxxxxx 4.15.0-43-generic #46~16.04.1-Ubuntu SMP Fri Dec 7 13:31:08 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

The full python stacktrace can be viewed as follows...

```
ansible-vault edit roles/cassandra_backup/vars/test_s3_cfg.yaml -vvv
```

```
Traceback (most recent call last):

  File "/usr/local/bin/ansible-vault", line 118, in<module>

    exit_code = cli.run()

  File "/usr/local/lib/python2.7/dist-packages/ansible/cli/vault.py", line 255, in run

    self.execute()

  File "/usr/local/lib/python2.7/dist-packages/ansible/cli/ __init__.py", line 155, in execute

    fn()

  File "/usr/local/lib/python2.7/dist-packages/ansible/cli/vault.py", line 446, in execute_edit

    self.editor.edit_file(f)

  File "/usr/local/lib/python2.7/dist-packages/ansible/parsing/vault/ __init__.py", line 953, in edit_file

    plaintext, vault_id_used, vault_secret_used = self.vault.decrypt_and_get_vault_id(vaulttext)

  File "/usr/local/lib/python2.7/dist-packages/ansible/parsing/vault/ __init__.py", line 736, in decrypt_and_get_vault_id

    b_plaintext = this_cipher.decrypt(b_vaulttext, vault_secret)

  File "/usr/local/lib/python2.7/dist-packages/ansible/parsing/vault/ __init__.py", line 1316, in decrypt

    b_key1, b_key2, b_iv = cls._gen_key_initctr(b_password, b_salt)

  File "/usr/local/lib/python2.7/dist-packages/ansible/parsing/vault/ __init__.py", line 1158, in _gen_key_initctr

    b_derivedkey = cls._create_key_cryptography(b_password, b_salt, key_length, iv_length)

  File "/usr/local/lib/python2.7/dist-packages/ansible/parsing/vault/ __init__.py", line 1131, in _create_key_cryptography

    b_derivedkey = kdf.derive(b_password)

  File "/usr/local/lib/python2.7/dist-packages/cryptography/hazmat/primitives/kdf/pbkdf2.py", line 50, in derive

    key_material

  File "/usr/local/lib/python2.7/dist-packages/cryptography/hazmat/backends/openssl/backend.py", line 307, in derive_pbkdf2_hmac

    key_material_ptr = self._ffi.from_buffer(key_material)

TypeError: from_buffer() cannot return the address of the raw string within a str or unicode or bytearray object
</module>
```

This is due to a problem with packages instakll via apt and pip. It can be fixed with the following procedure...

```
sudo -E pip uninstall cryptography -y
sudo -E apt-get purge python3-cryptography
sudo -E apt-get autoremove
sudo -E pip3 install --upgrade cryptography
```
