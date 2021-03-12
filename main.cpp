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

#include "dlgmodule.h"
#include "setpolicy.h"

#include <iostream>
#include <cstdlib>
#include <cstring>

using namespace dialog_module;

int main(int argc, const char **argv) {
  
  setpolicy();
  if (argc <= 2) return 0;

  if (strcmp(argv[1], "--show-message") == 0) {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_message((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--show-message-cancelable") == 0) {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_message_cancelable((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--show-question") == 0) {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_question((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--show-question-cancelable") == 0) {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_question_cancelable((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--show-attempt") == 0) {
    if (argc >= 4) widget_set_icon((char *)argv[3]); if (argc >= 5) widget_set_caption((char *)argv[4]);
    std::cout << show_attempt((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--show-error") == 0) {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << show_error((char *)argv[2], strtod(argv[3], nullptr)) << std::endl;
  }

  if (strcmp(argv[1], "--get-string") == 0) {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_string((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-password") == 0) {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_password((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-integer") == 0) {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_integer((char *)argv[2], strtod(argv[3], nullptr)) << std::endl;
  }

  if (strcmp(argv[1], "--get-passcode") == 0) {
    if (argc >= 5) widget_set_icon((char *)argv[4]); if (argc >= 6) widget_set_caption((char *)argv[5]);
    std::cout << get_passcode((char *)argv[2], strtod(argv[3], nullptr)) << std::endl;
  }

  if (strcmp(argv[1], "--get-open-filename") == 0) {
    std::cout << get_open_filename((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-open-filename-ext") == 0) {
    std::cout << get_open_filename_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (strcmp(argv[1], "--get-open-filenames") == 0) {
    std::cout << get_open_filenames((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-open-filenames-ext") == 0) {
    std::cout << get_open_filenames_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (strcmp(argv[1], "--get-save-filename") == 0) {
    std::cout << get_save_filename((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-save-filename-ext") == 0) {
    std::cout << get_save_filename_ext((char *)argv[2], (char *)argv[3], (char *)argv[4], (char *)argv[5]) << std::endl;
  }

  if (strcmp(argv[1], "--get-directory") == 0) {
    std::cout << get_directory((char *)argv[2]) << std::endl;
  }

  if (strcmp(argv[1], "--get-directory-alt") == 0) {
    std::cout << get_directory_alt((char *)argv[2], (char *)argv[3]) << std::endl;
  }

  if (strcmp(argv[1], "--get-color") == 0) {
    std::cout << get_color(strtod(argv[2], nullptr)) << std::endl;
  }

  if (strcmp(argv[1], "--get-color-ext") == 0) {
    std::cout << get_color_ext(strtod(argv[2], nullptr), (char *)argv[3]) << std::endl;
  }

  return 0;
}
