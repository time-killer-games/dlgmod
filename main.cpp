/*

 MIT License

 Copyright © 2019 Samuel Venable

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

*/

#include "dlgmod.h"

#include <iostream>
#include <string>

using namespace dialog_module;
using std::string;

int main(int argc, const char **argv) {

  if (string(argv[1]) == "--show-message") {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_message((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--show-message-cancelable") {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_message_cancelable((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--show-question") {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_question((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--show-question-cancelable") {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_question_cancelable((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--show-attempt") {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_attempt((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--show-error") {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << show_error((char *)argv[2], strtod(argv[3], NULL)) << std::endl;
  }

  if (string(argv[1]) == "--get-string") {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_string((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-password") {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_password((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-integer") {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_integer((char *)argv[2], strtod(argv[3], NULL)) << std::endl;
  }

  if (string(argv[1]) == "--get-passcode") {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_passcode((char *)argv[2], strtod(argv[3], NULL)) << std::endl;
  }

  if (string(argv[1]) == "--get-open-filename") {
    std::cout << get_open_filename((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-open-filename-ext") {
    std::cout << get_open_filename_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (string(argv[1]) == "--get-open-filenames") {
    std::cout << get_open_filenames((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-open-filenames-ext") {
    std::cout << get_open_filenames_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (string(argv[1]) == "--get-save-filename") {
    std::cout << get_save_filename((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-save-filename-ext") {
    std::cout << get_save_filename_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (string(argv[1]) == "--get-directory") {
    std::cout << get_directory((char *)argv[2]) << std::endl;
  }

  if (string(argv[1]) == "--get-directory-alt") {
    std::cout << get_directory_alt((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (string(argv[1]) == "--get-color") {
    std::cout << get_color(strtod(argv[2], NULL)) << std::endl;
  }

  if (string(argv[1]) == "--get-color-ext") {
    std::cout << get_color_ext(strtod(argv[2], NULL), (char *)argv[3]) << std::endl;
  }

  return 0;
}
