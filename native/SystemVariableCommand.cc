/*
    This file is part of GNU APL, a free implementation of the
    ISO/IEC Standard 13751, "Programming Language APL, Extended"

    Copyright (C) 2014  Elias Mårtenson

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "NetworkConnection.hh"
#include "SystemVariableCommand.hh"
#include "emacs.hh"

#include <sstream>

void SystemVariableCommand::run_command( NetworkConnection &conn, const std::vector<std::string> &args )
{
    stringstream out;

#define ro_sv_def(VAR, _str, txt) out << ID::get_name( ID::VAR ) << "\n";
#define rw_sv_def(VAR, _str, txt) out << ID::get_name( ID::VAR ) << "\n";
#define sf_def(FUN, _str, txt)    out << ID::get_name( ID::FUN ) << "\n";
#include "../SystemVariable.def"

    out << END_TAG << "\n";
    conn.write_string_to_fd( out.str() );
}
