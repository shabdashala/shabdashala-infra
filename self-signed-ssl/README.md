SSL Certificate Generation
==========================

`sslcerts.sh` is customized script taken from the article - https://tarunlalwani.com/post/self-signed-certificates-trusting-them/


## Generating the Root Certificate
```bash
$ ./sslcerts.sh create_root_cert
```

## Generating a Certificate signed using Root CA

* Before running next commands, ensure `san_env` section is added to `/etc/ssl/openssl.cnf`

```
(shabdashala-backend) ➜  self-signed-ssl git:(master) ✗ cat /etc/ssl/openssl.cnf 
[ req ]
#default_bits		= 2048
#default_md		= sha256
#default_keyfile 	= privkey.pem
distinguished_name	= req_distinguished_name
attributes		= req_attributes

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_min			= 2
countryName_max			= 2
stateOrProvinceName		= State or Province Name (full name)
localityName			= Locality Name (eg, city)
0.organizationName		= Organization Name (eg, company)
organizationalUnitName		= Organizational Unit Name (eg, section)
commonName			= Common Name (eg, fully qualified host name)
commonName_max			= 64
emailAddress			= Email Address
emailAddress_max		= 64

[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20

[ san_env ]
subjectAltName=${ENV::SAN}
```

* After ensuring `san_env` is present, run `export SSLEAY_CONFIG=-extensions san_env`

* Now, generate a Certificate signed using Root CA

```bash
$ SAN=DNS.1:*.shabdashala.com,DNS.2:shabdashala.com ./sslcerts.sh create_domain_cert '*.shabdashala.com'
```

References:
- http://docs.xaxo.eu/software/openssl/create-certification-authority.txt