# Copyright (c) 2023 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT
task default: :test

task :test do
  sh 'bolt plan run puppet::run --verbose'
end

task :run do
  sh 'git add .'
  sh 'git commit -m "update."'
  sh 'git push -u origin main'
end
