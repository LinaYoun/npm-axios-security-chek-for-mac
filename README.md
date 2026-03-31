다운로드 후, 내 모든 소스코드가 있는 폴더의 상위 폴더에 넣고
그 폴더에서 터미널을 연 후

./check-axios.sh

입력


혹시, 문제가 있다면,

For the Community: Recovery Step Downgrade axios to a clean version and pin it: npm install axios@1.14.0 # for 1.x users

npm install axios@0.30.3 # for 0.x users

Add an overrides block to prevent transitive resolution back to the malicious versions:

{ "dependencies": { "axios": "1.14.0" }, "overrides": { "axios": "1.14.0" }, "resolutions": { "axios": "1.14.0" } }

Remove plain-crypto-js from node_modules:

rm -rf node_modules/plain-crypto-js npm install --ignore-scripts

If a RAT artifact is found: treat the system as fully compromised. Do not attempt to clean in place — rebuild from a known-good state.

Rotate all credentials on any system where the malicious package ran: npm tokens, AWS access keys, SSH private keys, cloud credentials (GCP, Azure), CI/CD secrets, and any values present in .env files accessible at install time.

Audit CI/CD pipelines for runs that installed the affected versions. Any workflow that executed npm install with these versions should have all injected secrets rotated.

Use --ignore-scripts in CI/CD as a standing policy to prevent postinstall hooks from running during automated builds:

npm ci --ignore-scripts

Block C2 traffic at the network/DNS layer as a precaution on any potentially exposed system:

Block via firewall (Linux)

iptables -A OUTPUT -d 142.11.206.73-j DROP

Block via /etc/hosts (macOS/Linux)

echo "0.0.0.0 sfrclak.com" >> /etc/hosts
