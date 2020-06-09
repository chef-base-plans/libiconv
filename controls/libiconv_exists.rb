title 'Tests to confirm libiconv exists and works'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "libiconv")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-libiconv' do
  impact 1.0
  title 'Ensure libiconv exists and works as expected'
  desc '
  We check that the libiconv binary exists and checks the version to ensure it works.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  describe command("ls #{File.join(hab_pkg_path.stdout.strip, "bin/iconv")}") do
    its('stdout') { should_not be_empty }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  describe command("#{File.join(hab_pkg_path.stdout.strip, "bin/iconv")} --version") do
    its('stdout') { should match /iconv \(GNU libiconv [0-9]+.[0-9]+\)/ }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
end
