# RJS2 BOM 26.1 Migration Guide

## Overview

This document provides guidance towards major changes as part of RJS2 BOM 26.1 Release and steps to migrate to the latest BOM. The objective of this migration is to achieve consistency across Java projects in Revenue, they should all use a common parent POM and a common BOM for dependency management. These are updated on a regular (at least annual) basis, though not as often as the open source libraries themselves.

The latest BOM 26.1 introduces major breaking changes which constitutes of:

1. New BOM Version
2. OpenAM authentication is replaced with OIDC/ OAuth2 (KeyCloak) based authentication
3. Jackson 2.x migration to Jackson 3.x
4. General Spring ecosystem refactor

## Spring Framework 7 and Spring Boot 4 Key Changes

The 26.1 version of super-pom-java and rjs2-bom upgrade the version of Spring Framework to 7 and Spring Boot to 4. These are both major releases with some substantial changes:

> *Reference:*
>
> <https://github.com/spring-projects/spring-framework/wiki/Spring-Framework-7.0-Release-Notes>
>
> <https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Release-Notes>

The ones that stand out as being most important in Revenue are:

### RestTemplate deprecated

The RestTemplate was deemed "feature complete" in Spring 6 and is deprecated in Spring 7, with removal planned for Spring 8. With that in mind, we should look to migrate any uses of RestTemplate to either RestClient (the most straightforward change) or to HTTP Interfaces. For common libraries, they have been updated to use RestClient, but maintain compatibility with RestTemplate where possible.

### Jackson 3

Spring has moved to Jackson 3 across all its projects from this version onwards. While it keeps the old Jackson 2 support, including dependency management, this is scheduled for removal from Spring 7.2. So all our code should be updated to use Jackson 3. For common libraries, they have been updated to use Jackson 3 internally, but continue to support Jackson 2 where possible.

### Structured Logging

Spring Boot 4 introduces "structured logging" for more native logging in JSON format. This is an opportunity to remove the logback-logstash-encoder library from our stack in exchange for something simpler and more native to Spring Boot. Tomcat Access logging has also been updated to use this approach.

### JUnit 4 deprecated

JUnit 5 was the standard from Spring 6 and JUnit 6 (which should be backwards compatible with JUnit 5 from our perspective) is standard from Spring 6; JUnit 4 is deprecated, so any tests still using JUnit 4 should be updated.

### OpenAM and Keycloak

> [!NOTE]
> This is a major change when moving to 26.1 BOM

From this version of the rjs2-bom onwards, **OpenAM will no longer be supported.** Applications should move to OAuth2 with Keycloak.

Below libraries have been updated as part of this release:-

<table border="1" cellspacing="0" cellpadding="3" style="border-collapse: collapse; table-layout: fixed; width: 603px; max-width: 100%; border: 1px solid #cbd2dc; font-family: Arial, sans-serif; font-size: 12px; line-height: 19px; color: #000; background-color: #fff;">
  <colgroup>
    <col style="width: 30.6%;">
    <col style="width: 69.4%;">
  </colgroup>
  <thead>
    <tr>
      <th scope="col" style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word; background-color: #f0f2f4; font-weight: bold;">Library</th>
      <th scope="col" style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word; background-color: #f0f2f4; font-weight: bold;">Updates</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">super-pom-java</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated and built in Jenkins</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">rjs2-bom</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated and built in Jenkins</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-rest</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Deprecated RestTemplate; added class for customising RestClient in a similar way; added Jackson 3 equivalents for handling JAXB; removed custom Restful annotation processing (was added for Spring 3).</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">rjs2-command-center-client</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated to use RestClient but maintain compatibility with setting a BasicAuthRestTemplate.</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-management</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated to use Jackson 3, removed OpenAM in favour of OAuth2.</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-hadoop-config</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated to use RestClient, keep compatibility with RestTemplate.</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-hbase</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">No changes required</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-revstore-model</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated to use Jackson 3.</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-revstore</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Updated to Jackson3. Updated to use RestClient, keep compatibility with RestTemplate.</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">common-openam-security-parent</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Dropped. Replaced by common-keycloak-security-parent</td>
    </tr>
    <tr style="background-color: #fff;">
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">rev-spring-boot-parent</td>
      <td style="border: 1px solid #cbd2dc; padding: 3px; text-align: left; vertical-align: top; white-space: normal; overflow-wrap: break-word;">Dependencies updated and built in jenkins.</td>
    </tr>
  </tbody>
</table>

*Table 1. Updates to pom, bom and common libraries*

Subsequent pages provide comprehensive guides on the changes and example to move to RJS2-BOM 26.1
