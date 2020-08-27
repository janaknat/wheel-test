#!/bin/bash
set -e -u -x

cd /io/
rm -rf /io/wheelhouse
mkdir /io/wheelhouse
yum update -y
#/opt/python/cp39-cp39/bin/python3.9 /io/setup.py bdist_wheel
/opt/python/cp39-cp39/bin/pip3.9 install wheel
cp /io/dist/*.whl /io/
for whl in /io/*.whl; do
	if [ `uname -m` = 'aarch64' ]; then
		auditwheel repair $whl --plat "manylinux2014_aarch64" -w /io/
	else
		auditwheel repair $whl --plat "manylinux2014_x86_64" -w /io/
	fi
done
if [ `uname -m` = 'aarch64' ]; then
	/opt/python/cp39-cp39/bin/pip3.9 install /io/*-manylinux2014_aarch64.whl
else
	/opt/python/cp39-cp39/bin/pip3.9 install /io/*-manylinux2014_x86_64.whl
fi
