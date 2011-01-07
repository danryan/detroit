# detroit

Detroit is a super-simple Sinatra app for exporting your collectd RRDs as JSON.

## Installation

The `data` directory contains sample RRDs for demonstration purposes. RRDs are architecture specific so they may not work for you out of the box.

    git clone git://github.com/danryan/detroit.git
    cd detroit && rackup

When you're ready to use it on a real system with collectd, remove the `data` directory and update `config.yml` with the actual location of your RRDs


    