#!/bin/bash
# axios 감염 버전 검사 스크립트
# 사용법: ./check-axios.sh [검사할 경로 (기본: 현재 디렉토리)]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TARGET_DIR="${1:-.}"
INFECTED_VERSIONS=("1.14.1" "0.30.4")
FOUND_COUNT=0

echo "======================================"
echo " axios 감염 버전 검사기"
echo " 감염 버전: axios@1.14.1, axios@0.30.4"
echo " 검사 경로: $(cd "$TARGET_DIR" && pwd)"
echo "======================================"
echo ""

# package.json이 있는 디렉토리를 찾되, node_modules 내부는 제외
find "$TARGET_DIR" -name "node_modules" -prune -o -name "package.json" -print | while read -r pkg_json; do
    project_dir="$(dirname "$pkg_json")"

    # node_modules 폴더가 없으면 스킵
    if [ ! -d "$project_dir/node_modules" ]; then
        continue
    fi

    echo -e "${YELLOW}[검사중]${NC} $project_dir"

    # npm ls axios 실행 (에러 출력 포함, exit code 무시)
    output=$(cd "$project_dir" && npm ls axios 2>&1)

    for ver in "${INFECTED_VERSIONS[@]}"; do
        if echo "$output" | grep -q "axios@$ver"; then
            echo -e "${RED}[경고] 감염 버전 발견! axios@$ver${NC}"
            echo "$output" | grep "axios@$ver"
            FOUND_COUNT=$((FOUND_COUNT + 1))
        fi
    done
done

echo ""
echo "======================================"
if [ "$FOUND_COUNT" -eq 0 ]; then
    echo -e "${GREEN}검사 완료: 감염된 axios 버전이 발견되지 않았습니다.${NC}"
else
    echo -e "${RED}검사 완료: 감염된 버전이 발견되었습니다! 즉시 조치하세요.${NC}"
fi
echo "======================================"
