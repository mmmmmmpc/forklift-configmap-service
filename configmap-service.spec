Name:           configmap-service
Version:        0.0.1
Release:        4%{?dist}
Summary:        Konveyor Forklift ConfigMap Service.

License:        ASL 2.0
URL:            http://github.com/mperezco/forklift-configmap-service
Source0:        configmap-service.sh
Source1:        configmap.service

BuildRequires:  systemd
Requires:       bash

# disable debug packages and the stripping of the binaries
%global _enable_debug_package 0
%global debug_package %{nil}
%global __os_install_post /usr/lib/rpm/brp-compress %{nil}

%description
Konveyor Forklift ConfigMap Service. It enables VMs running on Kubernetes / KubeVirt to execute in them scripts provided as ConfigMaps after the main service has been started (i.e. OracleDB or PostgreSQL).

%prep
cp -av %{SOURCE0} .
cp -av %{SOURCE1} .

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p -m 755 $RPM_BUILD_ROOT%{_sbindir}
mkdir -p $RPM_BUILD_ROOT%{_unitdir}
install -p -m 644 configmap.service $RPM_BUILD_ROOT%{_unitdir}/
install -p -m 755 configmap-service.sh $RPM_BUILD_ROOT%{_sbindir}/

%pre

%post
%systemd_post configmap.service

%preun
%systemd_preun configmap.service

%postun
%systemd_postun configmap.service

%files
%defattr(-,root,root,600)

%attr(644,root,root) %{_unitdir}/configmap.service
%attr(755,root,root) %{_sbindir}/configmap-service.sh

%changelog
* Fri Sep 17 2021 Miguel Perez Colino <mperez@redhat.com> release 4
- Fixed installation path

* Tue Aug 10 2021 Miguel Perez Colino <mperez@redhat.com> release 3
- Fixed pre install script

* Tue Aug 10 2021 Miguel Perez Colino <mperez@redhat.com> release 2
- Fixed dependencies

* Tue Aug 10 2021 Miguel Perez Colino <mperez@redhat.com> release 1
- Initial RPM
