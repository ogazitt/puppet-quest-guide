describe "Task 1:" do
  it 'Create a node definition in your site.pp to configure your nodes for app deployment' do
    # Ugly! Pending direct method to test manifests
    file("#{PROD_PATH}manifests/site.pp")
      .content
      .should match /pe_ini_setting\s*{\s*['"]use_cached_catalog['"]\s*:
                       .*
                       setting\s*=>\s*['"]use_cached_catalog['"]\s*,
                       .*
                       pe_ini_setting\s*{\s*'pluginsync'\s*:
                       .*
                       setting\s*=>\s*'pluginsync',/mx
  end
end

describe "Task 2:" do
  it "Run puppet on your nodes to apply your configuration changes" do
    command('docker exec database puppet config print pluginsync use_cached_catalog --section agent')
      .stdout
      .should match /pluginsync\ =\ false\n
                     use_cached_catalog\ =\ true/x
    command('docker exec webserver puppet config print pluginsync use_cached_catalog --section agent')
      .stdout
      .should match /pluginsync\ =\ false\n
                     use_cached_catalog\ =\ true/x
  end
end

describe "Task 3:" do
  it "Create a client configuration file" do
    file("/root/.puppetlabs/client-tools/orchestrator.conf")
      .content
      .should match /"url":\s*"https:\/\/learning.puppetlabs.vm:8143"/
    file("/root/.puppetlabs/client-tools/orchestrator.conf")
      .content
      .should match /"environment":\s*"production"/
  end
end

describe "Task 4:" do
  it "Use the puppet access command to generate a token" do
    file('/root/.puppetlabs/token')
      .should be_file
  end
end

describe "Task 5:" do
  it "Create the directory structure of your lamp module" do
    file("#{MODULE_PATH}lamp/manifests")
      .should be_directory
    file("#{MODULE_PATH}lamp/lib/puppet/type")
      .should be_directory
  end
end

describe "Task 6:" do
  it "Create a sql type" do
    file("#{MODULE_PATH}lamp/lib/puppet/type/sql.rb")
      .content
      .should match /Puppet::Type\.newtype\s+:sql,\s+:is_capability\s+=>\s+true\s+do/
  end
end

describe "Task 7:" do
  it "Define a lamp::mysql component" do
    # Need a better test!
    file("#{MODULE_PATH}lamp/manifests/mysql.pp")
      .should be_file
  end
end

describe "Task 8:" do
  it "Define a lamp::webapp component" do
    # Need a better test!
    file("#{MODULE_PATH}lamp/manifests/webapp.pp")
      .should be_file
  end
end

describe "Task 9:" do
  it "Define the lamp application" do
    # Need a better test!
    file("#{MODULE_PATH}lamp/manifests/init.pp")
      .should be_file
  end
end

describe "Task 10:" do
  it "Declare an application instance in your site.pp manifest" do
    # Need a better test!
    file("#{PROD_PATH}manifests/site.pp")
      .content
      .should match /Node\[\s*['"]database\.learning\.puppetlabs\.vm['"],?\s*\]\s*=>\s*Lamp::Mysql\[\s*['"]app1['"],?\s*\],/
  end
end

describe "Task 11:" do
  it "Trigger a puppet job run to deploy your application" do
    command('docker exec webserver curl localhost/index.php')
      .stdout
      .should match /successfully/
  end
end
