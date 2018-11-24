/**
 * add_docs.cpp
 * 1. add_docs to list_md
 * 2. files will be downlaod to the dir
 * 3. books will open with foxit
 */
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <stack>
#include <sstream>
#include <climits>
#include <deque>
#include <set>
#include <utility>
#include <queue>
#include <map>
#include <cstring>
#include <algorithm>
#include <iterator>
#include <string>
#include <cassert>
#include <unordered_set>
#include <unordered_map>
#include <regex>

using namespace std;

/**
 * copyright belongs to:
 * https://stackoverflow.com/questions/5620235/cpp-regular-expression-to-validate-url
 */
int check_url(string & str){
    std::string url (str);

    std::regex url_regex (
        R"(^(([^:\/?#]+):)?(//([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?)",
        std::regex::extended
    );
    std::smatch url_match_result;

    std::cout << "Checking: " << url << std::endl;

    if (!std::regex_match(url, url_match_result, url_regex)) {
        std::cerr << "Malformed url." << std::endl;
        return -1;
    }

    std::cout << url << ": is valid" << std::endl;
    return 0;
}

const string doc_types[] = {"paper", "books"};

enum State {
    URL, TYPE, DESC
};
typedef enum State IO_State;

int main(int argc, const char *argv[]){
    IO_State s = URL;
    string url;

    for (std::string line; std::getline(std::cin, line);) {
        switch (s) {
            case URL:
                if(check_url(line) < 0){
                    return 0;
                }
                url = line;
                break;
            case TYPE:
                break;
            case DESC:
                break;
            default:
                std::cout << " impossible is valid" << std::endl;
        }
        std::cout << line << std::endl;
    }
    return 0;
}
