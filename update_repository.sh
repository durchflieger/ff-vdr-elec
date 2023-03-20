#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later

declare -A ADDONS_ID ADDONS_BASE_VERSION ADDONS_VERSION ADDONS_FILE BASE_VERSION_FILES NEED_NEW_ADDONS_FILE

base_version () {
  local IFS="."
	declare -a v
	v=(${1})
	BASE_VERSION="${v[0]}.${v[1]}"
	PKG_VERSION="${v[2]}"
}

read_dom () {
	local IFS=\>
	read -d \< ENTITY CONTENT
	local ret=$?
	TAG_NAME=${ENTITY%% *}
	ATTRIBUTES=${ENTITY#* }
	return $ret
}

parse_dom () {
	if [[ $TAG_NAME = "addon" ]] ; then
		eval local $ATTRIBUTES 2>/dev/null
		base_version "${version}"
		local key="${id}-${version}"

		if [ -z "${ADDONS_ID[${key}]}" ] ; then
			ADDONS_ID[${key}]="${id}"
			ADDONS_VERSION[${key}]="${version}"
			ADDONS_BASE_VERSION[${key}]="${BASE_VERSION}"
			ADDONS_FILE[${key}]="${ADDON_FILE}"
			BASE_VERSION_FILES[${BASE_VERSION}]="${BASE_VERSION_FILES[${BASE_VERSION}]} ${ADDON_FILE}"
			echo "Found addon id: $id version: $version file $ADDON_FILE"
		else
			echo "Skip addon id: $id version: $version file $ADDON_FILE"
		fi
	fi
}

parse_dom3 () {
	if [[ $TAG_NAME = "addon" ]] ; then
		eval local $ATTRIBUTES 2>/dev/null
		ADDON_ID="${id}"
		ADDON_VERSION="${version}"
	fi
}

read_addon_file () {
	while read_dom; do
		$1
	done
}

collect_addons () {
	for ADDON_FILE in ${ADDON_DIR}/*/*.zip ; do
		shopt -s lastpipe
		unzip -p "$ADDON_FILE" '*/addon.xml' | read_addon_file parse_dom
		shopt -u lastpipe
	done
}

copy_zip_files () {
	local key
  for key in ${!ADDONS_ID[@]} ; do
 		local	id="${ADDONS_ID[${key}]}"
		local version="${ADDONS_VERSION[${key}]}"
 		local	file="${ADDONS_FILE[${key}]}"
		local bv="${ADDONS_BASE_VERSION[${key}]}"
		local dst="${REPO_DIR}/${bv}/${id}"
		local name=`basename "$file"`
		if [ "$dst" != `dirname "$file"` ] ; then
			NEED_NEW_ADDONS_FILE[${bv}]=1
			NEED_NEW_README=1
			mkdir -p "$dst"
			cp "$file" "$dst"
			(cd "$dst" && sha256sum -b "$name" > "${name}.sha256")
			[ -n "${FOUND_GIT_REPO}" ] && git -C "${dst}" add "${name}" "${name}.sha256" && echo "new addon ${id} version ${version}" >> "$GIT_MSG"
			echo "New $file -> $dst"
		else
			echo "Keep $file"
		fi
	done
}

create_repository_addon_xml () {
	cat <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addon id="${REPO_ADDON_NAME}" name="${REPO_ADDON_NAME}" version="${REPO_ADDON_VERSION}" provider-name="${BUILDER_NAME}">
EOF
		#<dir minversion="${BASE_VERSION}.0" maxversion="${BASE_VERSION}.999">
  	#for BASE_VERSION in ${BASE_VERSION_LIST} ; do
  for BASE_VERSION in ${REPO_ADDON_BASE_VERSION} ; do
		local base_url="${REPO_URL}/${BASE_VERSION}"
		cat <<EOF
	<extension point="xbmc.addon.repository">
		<dir>
			<info>${base_url}/addons.xml</info>
			<checksum>${base_url}/addons.xml.sha256</checksum>
			<datadir>${base_url}/</datadir>
			<hashes>sha256</hashes>
		</dir>
	</extension>
EOF
	done
	cat <<EOF
	<extension point="xbmc.addon.metadata">
		<platform>all</platform>
			<news></news>
			<assets>
				<icon>resources/icon.png</icon>
				<fanart>resources/fanart.png</fanart>
			</assets>
	</extension>
</addon>
EOF
}

create_repository_addon () {
	local builddir=`mktemp -d`
	local builddst="${builddir}/${REPO_ADDON_NAME}"
	local dst="${REPO_DIR}/${REPO_ADDON_BASE_VERSION}/${REPO_ADDON_NAME}" 
	local file="${REPO_ADDON_NAME}-${REPO_ADDON_VERSION}.zip"
	mkdir -p "${builddst}/resources" "${dst}"
	create_repository_addon_xml > "${builddst}/addon.xml"
	cp "${FF_VDR_DISTRO_DIR}/repository/icon.png" "${FF_VDR_DISTRO_DIR}/repository/fanart.png" "${builddst}/resources"
	(cd ${builddir} && zip -rq "${file}" ${REPO_ADDON_NAME} && cp "${file}" "${REPO_ADDON_FILE}")
	(cd "$dst" && sha256sum -b "$file" > "${file}.sha256")
	[ -n "${FOUND_GIT_REPO}" ] && git -C "${dst}" add "${file}" "${file}.sha256" && echo "new addon ${REPO_ADDON_NAME} version ${REPO_ADDON_VERSION}" >> "$GIT_MSG"
	rm -rf "${builddir}"
	BASE_VERSION_FILES[${REPO_ADDON_BASE_VERSION}]="${BASE_VERSION_FILES[${REPO_ADDON_BASE_VERSION}]} ${REPO_ADDON_FILE}"
	echo "Created ${REPO_ADDON_FILE}"
}

create_addons_file () {
	echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
	echo "<addons>"
	local file
	for file in ${BASE_VERSION_FILES[${BASE_VERSION}]} ; do
		unzip -p "$file" '*/addon.xml' | tail +2
	done
	echo "</addons>"
}

create_addons_files () {
  for BASE_VERSION in ${BASE_VERSION_LIST} ; do
		local	dir="${REPO_DIR}/${BASE_VERSION}"
		local file="${dir}/addons.xml"
		if [ ! -f "$file" -o -n "${NEED_NEW_ADDONS_FILE[${BASE_VERSION}]}" ] ; then	
			create_addons_file > "${file}"
			(cd "${dir}" && sha256sum addons.xml > addons.xml.sha256)
			[ -n "${FOUND_GIT_REPO}" ] && git -C "${dir}" add addons.xml addons.xml.sha256 && echo "new/updated addons.xml for ${BASE_VERSION}" >> "$GIT_MSG"
			echo "Created ${file}"
		fi
	done
}

create_readme_addon_lists () {
  for BASE_VERSION in ${BASE_VERSION_LIST} ; do
		local file repo_addon_url
		declare -A addon_versions
		for file in ${BASE_VERSION_FILES[${BASE_VERSION}]} ; do
			shopt -s lastpipe
			unzip -p "$file" '*/addon.xml' | read_addon_file parse_dom3
			shopt -u lastpipe
			addon_versions[${ADDON_ID}]="${addon_versions[${ADDON_ID}]} ${ADDON_VERSION}"
			if [ "${ADDON_ID}" = "${REPO_ADDON_NAME}" ] ; then
				repo_addon_url="${REPO_URL}/${BASE_VERSION}/${REPO_ADDON_NAME}/${REPO_ADDON_NAME}-${ADDON_VERSION}.zip"
			fi
		done

		echo ""
		echo "### Addons for ${DISTRO}-Version: ${BASE_VERSION}"
		[ -n "${repo_addon_url}" ] && echo "To use this version download and copy this [ff-vdr repository kodi addon](${repo_addon_url}) to your device."
		echo ""
		echo "| Addon | Version |"
		echo "| ----- | ------- |"

		local addon_list=`echo $(printf '%s\n' ${!addon_versions[@]} | sort)`
		for file in ${addon_list} ; do
			echo "| ${file} | ${addon_versions[${file}]} |"
		done

		unset addon_versions repo_addon_url
	done
}

create_repository_readme () {
	FF_VDR_REPOSITORY_URL="${REPO_URL}/${REPO_ADDON_BASE_VERSION}/${REPO_ADDON_NAME}/${REPO_ADDON_NAME}-${REPO_ADDON_VERSION}.zip" \
	FF_VDR_ADDON_LIST=`create_readme_addon_lists` \
	envsubst < "${FF_VDR_DISTRO_DIR}/repository/README.in"
}

# --- main

[ -f ~/.ff-vdr-elec-options ] && source ~/.ff-vdr-elec-options

if [ -n "${FF_VDR_DISTRO_DIR}" ] ; then
	source ${FF_VDR_DISTRO_DIR}/config.sh
elif [ -f ~/ff-vdr-elec/config.sh ] ; then
	source ~/ff-vdr-elec/config.sh
else
	echo "could not find config.sh" && exit 1
fi

if [ -n "${GIT_REPO_URL}" ] ; then
	if [ -d "${REPO_DIR}" ] ; then
		[ -d "${REPO_DIR}/.git" ] && FOUND_GIT_REPO=1
		#[ -n "${FOUND_GIT_REPO}" ] && git -C "${REPO_DIR}" pull origin && git -C "${REPO_DIR}" reset --hard
	else
		git -C `dirname "${REPO_DIR}"` clone "${GIT_REPO_URL}" "${REPO_DIR}" && FOUND_GIT_REPO=1
	fi
fi

for d in $REPO_DIR $DISTRO_DIR/target/addons $FF_VDR_DISTRO_DIR ; do
	[ ! -d "$d" ] && echo "directory does not exists: ${d}" && exit 1
done

if [ -n "${GIT_REPO_URL}" ] ; then
	GIT_MSG="${REPO_DIR}/commit_msg"
	rm -f "$GIT_MSG"
	touch "$GIT_MSG"
fi

# collect existing addons from repository
for ADDON_DIR in `find $REPO_DIR -maxdepth 1 -type d -regex '.*/[0-9]+\.[0-9]+' -print` ; do
	collect_addons
done

# collect addons from system build
if [ -d "${DISTRO_DIR}/target/addons/${DEVICE}" ] ; then
	ADDON_DIR="${DISTRO_DIR}/target/addons/${DEVICE}/*/${ARCH}" collect_addons
else
	ADDON_DIR="${DISTRO_DIR}/target/addons/*/${PROJECT}/${ARCH}" collect_addons
fi

# copy new addons from system build
copy_zip_files

# Build sorted base version list
BASE_VERSION_LIST=`echo $(printf '%s\n' ${!BASE_VERSION_FILES[@]} | sort -r)`

# get actual repository addon
declare -a bvl=(${BASE_VERSION_LIST})
REPO_ADDON_BASE_VERSION=${bvl[0]}
REPO_ADDON_VERSION="${REPO_ADDON_BASE_VERSION}.100"
REPO_ADDON_FILE="${REPO_DIR}/${REPO_ADDON_BASE_VERSION}/${REPO_ADDON_NAME}/${REPO_ADDON_NAME}-${REPO_ADDON_VERSION}.zip"
[ ! -f "${REPO_ADDON_FILE}" ] && create_repository_addon
echo "Actual ${REPO_ADDON_NAME} addon is ${REPO_ADDON_VERSION}"

create_addons_files

if [ -n "${NEED_NEW_README}" -o ! -f "${REPO_DIR}/README.md" ] ; then
	create_repository_readme > "${REPO_DIR}/README.md"
	[ -n "${FOUND_GIT_REPO}" ] && git -C "${REPO_DIR}" add README.md && echo "new/updated README.md" >> "$GIT_MSG"
	echo "Created ${REPO_DIR}/README.md"
fi

if [ -n "${FOUND_GIT_REPO}" ] ; then
	if [ -s "${GIT_MSG}" ] ; then
		if [ "${GIT_COMMIT}" = "yes" ] ; then
			git -C "${REPO_DIR}" commit -F "$GIT_MSG" && git -C "${REPO_DIR}" push origin && echo "Changes commited and pushed"
		else
			echo "cd to $REPO_DIR and commit and push changes with:"
			echo "git commit -F $GIT_MSG && git push origin"
		fi
	else
		echo "Nothing to commit"
	fi
fi
