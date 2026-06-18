#!/bin/bash

source ../config-funcs.sh

dpcfg=$1
prefix=$2
zomafile=$3

valcred=""

# jq query input
domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

name=$prefix
idcred=$prefix

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:set-config>
<SSLClientProfile xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="$name">
	<mAdminState>enabled</mAdminState>
	<Protocols>
		<SSLv3>off</SSLv3>
		<TLSv1d0>off</TLSv1d0>
		<TLSv1d1>on</TLSv1d1>
		<TLSv1d2>on</TLSv1d2>
		<TLSv1d3>on</TLSv1d3>
	</Protocols>
	<Ciphers>AES_256_GCM_SHA384</Ciphers>
	<Ciphers>CHACHA20_POLY1305_SHA256</Ciphers>
	<Ciphers>AES_128_GCM_SHA256</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_256_GCM_SHA384</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_256_CBC_SHA384</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_128_GCM_SHA256</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_128_CBC_SHA256</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_256_CBC_SHA</Ciphers>
	<Ciphers>ECDHE_ECDSA_WITH_AES_128_CBC_SHA</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_256_GCM_SHA384</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_256_CBC_SHA384</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_128_GCM_SHA256</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_128_CBC_SHA256</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_256_CBC_SHA</Ciphers>
	<Ciphers>ECDHE_RSA_WITH_AES_128_CBC_SHA</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_256_GCM_SHA384</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_256_CBC_SHA256</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_128_GCM_SHA256</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_128_CBC_SHA256</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_256_CBC_SHA</Ciphers>
	<Ciphers>DHE_RSA_WITH_AES_128_CBC_SHA</Ciphers>
	<Idcred class="CryptoIdentCred">$idcred</Idcred>
	<ValidateServerCert>off</ValidateServerCert>
	<Caching>on</Caching>
	<CacheTimeout>300</CacheTimeout>
	<CacheSize>100</CacheSize>
	<SSLClientFeatures>
		<use-sni>on</use-sni>
		<permit-insecure-servers>off</permit-insecure-servers>
		<compression>off</compression>
	</SSLClientFeatures>
	<EllipticCurves>secp521r1</EllipticCurves>
	<EllipticCurves>secp384r1</EllipticCurves>
	<EllipticCurves>secp256k1</EllipticCurves>
	<EllipticCurves>secp256r1</EllipticCurves>
	<UseCustomSNIHostname>no</UseCustomSNIHostname>
	<ValidateHostname>off</ValidateHostname>
	<HostnameValidationFailOnError>off</HostnameValidationFailOnError>
	<EnableTLS13Compat>on</EnableTLS13Compat>
	<DisableRenegotiation>off</DisableRenegotiation>
	<SigAlgs>ecdsa_secp256r1_sha256</SigAlgs>
	<SigAlgs>ecdsa_secp384r1_sha384</SigAlgs>
	<SigAlgs>ecdsa_secp521r1_sha512</SigAlgs>
	<SigAlgs>ed25519</SigAlgs>
	<SigAlgs>ed448</SigAlgs>
	<SigAlgs>rsa_pss_pss_sha256</SigAlgs>
	<SigAlgs>rsa_pss_pss_sha384</SigAlgs>
	<SigAlgs>rsa_pss_pss_sha512</SigAlgs>
	<SigAlgs>rsa_pss_rsae_sha256</SigAlgs>
	<SigAlgs>rsa_pss_rsae_sha384</SigAlgs>
	<SigAlgs>rsa_pss_rsae_sha512</SigAlgs>
	<SigAlgs>rsa_pkcs1_sha256</SigAlgs>
	<SigAlgs>rsa_pkcs1_sha384</SigAlgs>
	<SigAlgs>rsa_pkcs1_sha512</SigAlgs>
	<SigAlgs>ecdsa_sha224</SigAlgs>
	<SigAlgs>ecdsa_sha1</SigAlgs>
	<SigAlgs>rsa_pkcs1_sha224</SigAlgs>
	<SigAlgs>rsa_pkcs1_sha1</SigAlgs>
	<SigAlgs>dsa_sha224</SigAlgs>
	<SigAlgs>dsa_sha1</SigAlgs>
	<SigAlgs>dsa_sha256</SigAlgs>
	<SigAlgs>dsa_sha384</SigAlgs>
	<SigAlgs>dsa_sha512</SigAlgs>
</SSLClientProfile>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

