// Filename: programBase.h
// Created by:  drose (13Feb00)
//
////////////////////////////////////////////////////////////////////
//
// PANDA 3D SOFTWARE
// Copyright (c) 2001, Disney Enterprises, Inc.  All rights reserved
//
// All use of this software is subject to the terms of the Panda 3d
// Software license.  You should have received a copy of this license
// along with this source code; you will also find a current copy of
// the license at http://www.panda3d.org/license.txt .
//
// To contact the maintainers of this program write to
// panda3d@yahoogroups.com .
//
////////////////////////////////////////////////////////////////////

#ifndef PROGRAMBASE_H
#define PROGRAMBASE_H

#include <pandatoolbase.h>

#include <distanceUnit.h>
#include <filename.h>
#include <vector_string.h>

#include <string>
#include "pvector.h"
#include "pdeque.h"
#include "pmap.h"

////////////////////////////////////////////////////////////////////
//       Class : ProgramBase
// Description : This is intended to be the base class for most
//               general-purpose utility programs in the PANDATOOL
//               tree.  It automatically handles things like
//               command-line arguments in a portable way.
////////////////////////////////////////////////////////////////////
class ProgramBase {
public:
  ProgramBase();
  virtual ~ProgramBase();

  void show_description();
  void show_usage();
  void show_options();

  INLINE void show_text(const string &text);
  void show_text(const string &prefix, int indent_width, string text);

  virtual void parse_command_line(int argc, char *argv[]);

  typedef pdeque<string> Args;
  Filename _program_name;
  Args _program_args;

protected:
  typedef bool (*OptionDispatchFunction)(const string &opt, const string &parm, void *data);
  typedef bool (*OptionDispatchMethod)(ProgramBase *self, const string &opt, const string &parm, void *data);

  virtual bool handle_args(Args &args);
  virtual bool post_command_line();

  void set_program_description(const string &description);
  void clear_runlines();
  void add_runline(const string &runline);
  void clear_options();
  void add_option(const string &option, const string &parm_name,
                  int index_group, const string &description,
                  OptionDispatchFunction option_function,
                  bool *bool_var = (bool *)NULL,
                  void *option_data = (void *)NULL);
  void add_option(const string &option, const string &parm_name,
                  int index_group, const string &description,
                  OptionDispatchMethod option_method,
                  bool *bool_var = (bool *)NULL,
                  void *option_data = (void *)NULL);
  bool redescribe_option(const string &option, const string &description);
  bool remove_option(const string &option);

  static bool dispatch_none(const string &opt, const string &arg, void *);
  static bool dispatch_true(const string &opt, const string &arg, void *var);
  static bool dispatch_false(const string &opt, const string &arg, void *var);
  static bool dispatch_count(const string &opt, const string &arg, void *var);
  static bool dispatch_int(const string &opt, const string &arg, void *var);
  static bool dispatch_int_pair(const string &opt, const string &arg, void *var);
  static bool dispatch_double(const string &opt, const string &arg, void *var);
  static bool dispatch_double_pair(const string &opt, const string &arg, void *var);
  static bool dispatch_double_triple(const string &opt, const string &arg, void *var);
  static bool dispatch_double_quad(const string &opt, const string &arg, void *var);
  static bool dispatch_color(const string &opt, const string &arg, void *var);
  static bool dispatch_string(const string &opt, const string &arg, void *var);
  static bool dispatch_filename(const string &opt, const string &arg, void *var);
  static bool dispatch_search_path(const string &opt, const string &arg, void *var);
  static bool dispatch_coordinate_system(const string &opt, const string &arg, void *var);
  static bool dispatch_units(const string &opt, const string &arg, void *var);
  static bool dispatch_image_type(const string &opt, const string &arg, void *var);

  static bool handle_help_option(const string &opt, const string &arg, void *);

  static void format_text(ostream &out, bool &last_newline,
                          const string &prefix, int indent_width,
                          const string &text, int line_width);

private:
  void sort_options();
  void get_terminal_width();

  class Option {
  public:
    string _option;
    string _parm_name;
    int _index_group;
    int _sequence;
    string _description;
    OptionDispatchFunction _option_function;
    OptionDispatchMethod _option_method;
    bool *_bool_var;
    void *_option_data;
  };

  class SortOptionsByIndex {
  public:
    bool operator () (const Option *a, const Option *b) const;
  };

  string _description;
  typedef vector_string Runlines;
  Runlines _runlines;

  typedef pmap<string, Option> OptionsByName;
  typedef pvector<const Option *> OptionsByIndex;
  OptionsByName _options_by_name;
  OptionsByIndex _options_by_index;
  int _next_sequence;
  bool _sorted_options;

  typedef pmap<string, string> GotOptions;
  GotOptions _got_options;

  bool _last_newline;
  int _terminal_width;
  bool _got_terminal_width;
  int _option_indent;
  bool _got_option_indent;
};

#include "programBase.I"

#endif


