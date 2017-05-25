#!/usr/bin/env python
import argparse
import base64
import yaml

def load_spec_str(spec_path):
    """
    returns the contents of a file
    """
    with open(spec_path, 'r') as spec_file:
        return spec_file.read()

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--spec', help='APB Spec File Path (e.g. ~/git/my_apb/apb.yml)', required=True)
    parser.add_argument('-q', '--quiet', help='Run Quiet, only outputs the BLOB', action='store_true', required=False)
    args = parser.parse_args()

    spec_path = args.spec

    print_full = True
    if args.quiet:
        print_full = False
    
    # base64 encode the spec file
    blob = base64.b64encode(load_spec_str(spec_path))

    if print_full:
        print "\nBase64 Encoded BLOB for the APB specfile is : " 

    print "%s" % blob
