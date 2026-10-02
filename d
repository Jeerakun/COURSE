<div style="max-width: 720px; margin: 0 auto; padding: 20px 24px; font-family: Arial, sans-serif; font-size: 12px; line-height: 1.65; color: #000; background-color: #fff;">
<h1 style="font-size: 24px; line-height: 1.3; margin: 18px 0 8px; font-weight: bold;">BOM Version Uplift</h1>
<h2 style="font-size: 18px; line-height: 1.3; margin: 18px 0 8px; font-weight: bold;">Overview</h2>
<p style="margin: 6px 0;">As part of this task, the objective is to establish a stable and reproducible build post migrating to 26.1 BOM version.</p>
<p style="margin: 6px 0;">Below are the high level tasks as part of this phase:-</p>
<ol style="margin: 4px 0 8px; padding-left: 16px;">
<li>Upgrade maven dependency lineage:
<ol type="a" style="margin: 3px 0; padding-left: 20px;"><li><em>super-pom-java</em>, <em>rjs2-bom</em> and project parent versions.</li></ol></li>
<li>Align module versions to the same parent line</li>
</ol>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Success Criteria</h3>
<ol style="margin: 4px 0 8px; padding-left: 16px;">
<li>Clean compile across all target modules.</li>
<li>No duplicate or conflicting major versions of critical libraries.</li>
<li>Deterministic dependency graph</li>
</ol>
<h2 style="font-size: 18px; line-height: 1.3; margin: 18px 0 8px; font-weight: bold;">Implementation flow</h2>
<p style="margin: 6px 0;">Below is the most common way to uplift BOM version</p>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Step 1: Upgrade root parent and BOM import first</h3>
<p style="margin: 6px 0;">Example root POM</p>
<div style="margin: 8px 0 14px; padding: 8px 18px 14px; background-color: #f7f8f9; border-radius: 3px;">
<p style="margin: 0 0 10px; text-align: right; font-size: 10px; color: #334155;">xml</p>
<pre style="margin: 0; padding: 0; border: 0; background: transparent; white-space: pre-wrap; overflow-wrap: anywhere; font-family: Consolas, monospace; font-size: 11px; line-height: 1.6;"><code><span style="color: #e00000;">&lt;parent&gt;</span>
  <span style="color: #e00000;">&lt;groupId&gt;</span>ie.revenue.common.maven<span style="color: #e00000;">&lt;/groupId&gt;</span>
  <span style="color: #e00000;">&lt;artifactId&gt;</span>super-pom-java<span style="color: #e00000;">&lt;/artifactId&gt;</span>
  <span style="color: #e00000;">&lt;version&gt;</span>26.1.0-SNAPSHOT<span style="color: #e00000;">&lt;/version&gt;</span>
<span style="color: #e00000;">&lt;/parent&gt;</span>

<span style="color: #e00000;"><dependencyManagement></span>
<span style="color: #e00000;"><dependencies></span>
<span style="color: #e00000;"><dependency></span>
<span style="color: #e00000;"><groupId></span>ie.revenue.common<span style="color: #e00000;"></groupId></span>
<span style="color: #e00000;"><artifactId></span>rjs2-bom<span style="color: #e00000;"></artifactId></span>
<span style="color: #e00000;"><version></span>26.1.0-SNAPSHOT<span style="color: #e00000;"></version></span>
<span style="color: #e00000;"><type></span>pom<span style="color: #e00000;"></type></span>
<span style="color: #e00000;"><scope></span>import<span style="color: #e00000;"></scope></span>
<span style="color: #e00000;"></dependency></span>
<span style="color: #e00000;"></dependencies></span>
<span style="color: #e00000;"></dependencyManagement></span></code></pre>

</div>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Step 2: Align all module parent versions</h3>
<p style="margin: 6px 0;">Every module should inherit the same project parent version.</p>
<div style="margin: 8px 0 14px; padding: 8px 18px 14px; background-color: #f7f8f9; border-radius: 3px;">
<p style="margin: 0 0 10px; text-align: right; font-size: 10px; color: #334155;">xml</p>
<pre style="margin: 0; padding: 0; border: 0; background: transparent; white-space: pre-wrap; overflow-wrap: anywhere; font-family: Consolas, monospace; font-size: 11px; line-height: 1.6;"><code><span style="color: #e00000;">&lt;parent&gt;</span>
  <span style="color: #e00000;">&lt;groupId&gt;</span>ie.revenue.customer.notes<span style="color: #e00000;">&lt;/groupId&gt;</span>
  <span style="color: #e00000;">&lt;artifactId&gt;</span>customer-notes-parent<span style="color: #e00000;">&lt;/artifactId&gt;</span>
  <span style="color: #e00000;">&lt;version&gt;</span>26.3.0-SNAPSHOT<span style="color: #e00000;">&lt;/version&gt;</span>
<span style="color: #e00000;">&lt;/parent&gt;</span></code></pre>
</div>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Step 3: Keep code edits minimal</h3>
<p style="margin: 6px 0;">It is best to only do compile fix edits:-</p>
<ol style="margin: 4px 0 8px; padding-left: 16px;">
<li>package/import moves required by upgraded libs.</li>
<li>API signature changes needed to compile.</li>
<li>replacement of removed framework classes with direct equivalents.</li>
</ol>
<div role="note" style="margin: 10px 0; padding: 9px 12px; border-radius: 3px; background-color: #e6effc;"><span aria-hidden="true" style="display: inline-block; margin-right: 12px; width: 13px; height: 13px; border-radius: 50%; background-color: #1769d2; color: white; text-align: center; font-size: 10px; line-height: 13px; font-weight: bold;">i</span>Avoid behaviour changes unless compile blocks force them.</div>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">(Optional) Step 4: Generate dependency tree to verify BOM updates</h3>
<p style="margin: 6px 0;">Run these commands locally to verify.</p>
<div style="margin: 8px 0 14px; padding: 8px 18px 14px; background-color: #f7f8f9; border-radius: 3px;">
<p style="margin: 0 0 10px; text-align: right; font-size: 10px; color: #334155;">bash</p>
<pre style="margin: 0; padding: 0; border: 0; background: transparent; white-space: pre-wrap; overflow-wrap: anywhere; font-family: Consolas, monospace; font-size: 11px; line-height: 1.6;"><code>mvn -q -DskipTests dependency:tree -DoutputType=text -DoutputFile=target/dependency-tree.txt
mvn -q -DskipTests help:effective-pom -Doutput=target/effective-pom.xml</code></pre>
</div>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Step 5: Compile and verify</h3>
<p style="margin: 6px 0;">Minimal compilation check</p>
<div style="margin: 8px 0 14px; padding: 8px 18px 14px; background-color: #f7f8f9; border-radius: 3px;">
<p style="margin: 0 0 10px; text-align: right; font-size: 10px; color: #334155;">bash</p>
<pre style="margin: 0; padding: 0; border: 0; background: transparent; white-space: pre-wrap; overflow-wrap: anywhere; font-family: Consolas, monospace; font-size: 11px; line-height: 1.6;"><code>mvn -B -U -DskipTests clean compile</code></pre>
</div>
<h3 style="font-size: 12px; line-height: 1.3; margin: 12px 0 6px; font-weight: bold;">Best Practices</h3>
<p style="margin: 6px 0;">Move Version pinning into one place. Let BOM manage versions by default.</p>
<ol style="margin: 4px 0 8px; padding-left: 16px;">
<li>Import BOM in root.</li>
<li>Remove child explicit versions unless required.</li>
</ol>
<div style="margin: 8px 0 14px; padding: 8px 18px 14px; background-color: #f7f8f9; border-radius: 3px;">
<p style="margin: 0 0 10px; text-align: right; font-size: 10px; color: #334155;">xml</p>
<pre style="margin: 0; padding: 0; border: 0; background: transparent; white-space: pre-wrap; overflow-wrap: anywhere; font-family: Consolas, monospace; font-size: 11px; line-height: 1.6;"><code><span style="color: #e00000;">&lt;dependency&gt;</span>
  <span style="color: #e00000;">&lt;groupId&gt;</span>org.springframework.boot<span style="color: #e00000;">&lt;/groupId&gt;</span>
  <span style="color: #e00000;">&lt;artifactId&gt;</span>spring-boot-starter-web<span style="color: #e00000;">&lt;/artifactId&gt;</span>
<span style="color: #e00000;">&lt;/dependency&gt;</span></code></pre>
</div>
<h2 style="font-size: 18px; line-height: 1.3; margin: 18px 0 8px; font-weight: bold;">Spring Changes</h2>
<p style="margin: 6px 0;">JacksonHttpConverter change goes here</p>
</div>
