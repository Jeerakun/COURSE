# BOM Version Uplift

## Overview

As part of this task, the objective is to establish a stable and reproducible build post migrating to 26.1 BOM version.

Below are the high level tasks as part of this phase:

1. Upgrade maven dependency lineage:
   - *super-pom-java*, *rjs2-bom* and project parent versions.
2. Align module versions to the same parent line.

### Success Criteria

1. Clean compile across all target modules.
2. No duplicate or conflicting major versions of critical libraries.
3. Deterministic dependency graph.

## Implementation flow

Below is the most common way to uplift BOM version.

### Step 1: Upgrade root parent and BOM import first

Example root POM:

```xml
<parent>
  <groupId>ie.revenue.common.maven</groupId>
  <artifactId>super-pom-java</artifactId>
  <version>26.1.0-SNAPSHOT</version>
</parent>

<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>ie.revenue.common</groupId>
      <artifactId>rjs2-bom</artifactId>
      <version>26.1.0-SNAPSHOT</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

### Step 2: Align all module parent versions

Every module should inherit the same project parent version.

```xml
<parent>
  <groupId>ie.revenue.customer.notes</groupId>
  <artifactId>customer-notes-parent</artifactId>
  <version>26.3.0-SNAPSHOT</version>
</parent>
```

### Step 3: Keep code edits minimal

It is best to only do compile fix edits:

1. package/import moves required by upgraded libs.
2. API signature changes needed to compile.
3. replacement of removed framework classes with direct equivalents.

> **Note:** Avoid behaviour changes unless compile blocks force them.

### (Optional) Step 4: Generate dependency tree to verify BOM updates

Run these commands locally to verify.

```bash
mvn -q -DskipTests dependency:tree -DoutputType=text -DoutputFile=target/dependency-tree.txt
mvn -q -DskipTests help:effective-pom -Doutput=target/effective-pom.xml
```

### Step 5: Compile and verify

Minimal compilation check:

```bash
mvn -B -U -DskipTests clean compile
```

### Best Practices

Move Version pinning into one place. Let BOM manage versions by default.

1. Import BOM in root.
2. Remove child explicit versions unless required.

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

## Spring Changes

JacksonHttpConverter change goes here
