#$ aws waf-regional list-ip-sets --profile lab
#{
#    "NextMarker": "ffcc144e-****-****-****-d63fdc6e63cb",
#    "IPSets": [
#        {
#            "IPSetId": "45f5cd3e-****-****-****-196eca91590c",
#            "Name": "pm-lab-lb-waf-WAFReputationListsSet1"
#        },
#        {
#            "IPSetId": "ffcc144e-****-****-****-d63fdc6e63cb",
#            "Name": "pm-lab-lb-waf-WAFReputationListsSet2"
#            }
#        ]
#}

#$ python clean-ipset.py --profile lab --setid 45f5cd3e-****-****-****-196eca91590c

#$ python clean-ipset.py --profile lab --setid ffcc144e-****-****-****-d63fdc6e63cb

import boto3

import optparse

parser = optparse.OptionParser()
parser.add_option('--setid', help='SetID via aws waf list-set-ids or aws waf-regional list-set-ids')
parser.add_option('--profile', help='AWS Profile as in ~/.aws/credentials file')
(options, args) = parser.parse_args()

if not options.setid:
  parser.error("Missing setid")
if not options.profile:
  parser.error("Missing profile")


def chunks(l, n):
  """Yield successive n-sized chunks from l."""
  for i in range(0, len(l), n):
    yield l[i:i + n]

session = boto3.Session(profile_name= options.profile)
client = session.client("waf-regional")


ipset = client.get_ip_set(IPSetId = options.setid)
count = 1

for chunk in chunks(ipset['IPSet']['IPSetDescriptors'], 500):
  delete_set = []
  for item in chunk:
    delete_set.append({'Action':'DELETE','IPSetDescriptor':{'Type':item['Type'], 'Value':item['Value']}})
  token = client.get_change_token()
  response = client.update_ip_set( ChangeToken=token['ChangeToken'], IPSetId=options.setid, Updates=delete_set)
  print "On count {0} of delete... ".format(count)
  count += 1
