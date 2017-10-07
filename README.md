# DTD for alternate Gentoo metadata (metadata-alt)

## Background
metadata-alt defines a DTD for additional or alternate package metadata that
should be useful to Gentoo package maintainers. It is intended to supplement,
not replace, the package metadata.xml defined in [GLEP 68][].

Initially, metadata-alt was created to expand on the upstream/remote-id
elements to assist automated package updates and version checks. It has grown
to include a number of additional elements that can be used to ensure ebuilds
more closely track upstream development.

This document gives an overview of elements of metadata-alt and appropriate
usage guidelines for both overlay maintainers and developers writing tools to
consume the additional metadata.

## Elements
### upstream
#### remote-id
The **remote-id** element is similar in function to the GLEP 68 metadata.xml
but is expanded to include a *url* attribute. This is useful for projects
published on self-hosted platforms. For example, under GLEP 68, the "gitlab"
type must assume a repository at gitlab.com but this is not always the case.

#### version-check and no-versioning
The **version-check** element complements the **remote-id** element. In many
cases it makes sense to track a remote repository for version information.
However, sometimes one is not available, it does not have tags for releases, or
it is out of sync with published releases. The **version-check** element
provides an alternate source for version information in these cases. It assumes
a modular architecture where the *type* attribute indicates which child
elements should be present or are significant.

Currently in use by one tool, the "soup" *type* provides a set of **try**
elements that contain a *url* attribute and one or more **regexp** elements
each having a *tag* and, optionally, an *attr*. This provides a fairly flexible
way of storing multiple URLs and regular expressions that can be used by
something like [Beautiful Soup][] to read version information directly from the
web.

Conversely, the **no-versioning** element can be used to indicate that the
upstream project does not have any version scheme. This is useful for projects
that demand end-users believe a particular branch is stable and production
ready. It could be used to indicate when a tool should fallback on comparing
commits or dates rather than versions.

#### normalize
The **normalize** element is used to record a set of rules to transform
upstream tags or versions into Gentoo ebuild versions. Each normalize rule
should have a *type* attribute to indicate the **remote-id** or
**version-check** to which it should be applied. A **rule** element contains a
straightforward pair of **replace** and **with** elements. It is anticipated
that **replace** will typically contain a regular expression.

In most cases the **normalize** element will not be necessary. It should only
be used in exceptional cases.

### patches
#### patch
The **patch** element is loosely defined to track patches in Gentoo between
ebuild versions. Each patch has a *status* attribute indicating whether it is
Gentoo specific or has been accepted upstream.

The *status* attribute should initially be set to the value "gentoo-specific",
for compiler option fixes, library paths, etc, or to the value
"upstream-possible" when the patch is being sent upstream. The value
"upstream-accepted" should be used to indicate when a patch has been accepted
upstream but has not yet been included in a new upstream release. The value
"gentoo-specific" may also be used to indicate when a patch has been rejected
upstream but is still necessary.

## Usage (in overlays)
Overlay maintainers wishing to make use of metadata-alt should write a
conforming metadata-alt.xml file adjacent to a package metadata.xml file. Under
no circumstances should the two files be combined as this will break tools that
depend on a strictly-conforming metadata.xml.

xmllint may be used to test conformance:

    xmllint --noout --valid metadata-alt.xml

Care has been taken to avoid duplicating information from the GLEP 68 package
metadata. However, in cases where it is possible to represent the same metadata
in both files, preference should be given to storing it in metadata.xml.

## Usage (in tools)
Care has been taken to avoid duplicating information from the GLEP 68 package
metadata. Therefore it is generally sufficient for tools to simply merge the
information read from metadata-alt.xml with the information read from
metadata.xml. However, in cases where there is a collision, preference should
be given to information from metadata.xml unless there are elements or
attributes from metadata-alt.xml that provide additional information.

[GLEP 68]:        https://wiki.gentoo.org/wiki/GLEP:68
[Beautiful Soup]: https://www.crummy.com/software/BeautifulSoup
