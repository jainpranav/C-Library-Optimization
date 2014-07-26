#include "EntryParser.hpp"
#include "tokenizer.hpp"
#include <string>
#include <iostream>
using namespace std;

class MainParser;

bool f1(MainParser&) {
	cerr << "aaa" << endl;
	return true;
}
bool f2(MainParser&) {
	cerr << "obb" << endl;
	return true;
}
bool f3(MainParser&) {
	cerr << "ccc" << endl;
}
class MainParser : public EntryParser<MainParser>{
	public:
		typedef EntryParser::Iter Iter;

		MainParser() {
			add(Token("aaa"), &f1);
			add(Token("bbb"), &f2);
			Tokens tk;
			tk.push_back("aaa");
			tk.push_back("bbb");
			add(tk, &f3);
		}

		bool setStatement(Iter& iter, Iter end) {
			entries.head();
			entries.find(Tuple("cc", nullptr));
			EntryParser<MainParser>::setStatement(iter, end);
			cout << "parseresult" << entries.value() << endl;
			entries.value().action(*this);

			return true;
		}
	private:
};

int main(void) {
	MainParser mp;
	string str = "aaa bbb";
	Tokenizer tk;
	tk.set(str);
	auto iter = tk.begin();
	mp.setStatement(iter, tk.end());
	if (mp.fail()) {
		cerr << mp.what() << " at " << mp.where().tk << endl;
	}
	str= "aaa";
	tk.set(str);
	iter = tk.begin();
	mp.setStatement(iter, tk.end());
	if (mp.fail()) {
		cerr << mp.what() << " at " << mp.where().tk << endl;
	}
	return 0;
}
