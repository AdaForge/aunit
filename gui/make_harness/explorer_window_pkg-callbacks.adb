------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       Explorer_Window_Pkg.Callbacks                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision$
--                                                                          --
--                Copyright (C) 2001 Ada Core Technologies, Inc.            --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, --
-- MA 02111-1307, USA.                                                      --
--                                                                          --
-- GNAT is maintained by Ada Core Technologies Inc (http://www.gnat.com).   --
--                                                                          --
------------------------------------------------------------------------------

with Glib; use Glib;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Widget; use Gtk.Widget;
with Gtk.GEntry; use Gtk.GEntry;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.OS_Lib; use GNAT.OS_Lib;
with Make_Harness_Window_Pkg; use Make_Harness_Window_Pkg;

package body Explorer_Window_Pkg.Callbacks is
   --  Handle callbacks from the file selection window.  Template
   --  generated by Glade

   -------------------------------------
   -- On_Explorer_Window_Delete_Event --
   -------------------------------------

   function On_Explorer_Window_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean
   is
   begin
      Hide_All (Get_Toplevel (Object));
      return True;
   end On_Explorer_Window_Delete_Event;

   -------------------------
   -- On_Clist_Select_Row --
   -------------------------

   procedure On_Clist_Select_Row
     (Object : access Gtk_Clist_Record'Class;
      Params : Gtk.Arguments.Gtk_Args)
   is
      --  Handle directory or file selection action

      function Dir_Name (Old_Dir : String;
                         New_Dir : String) return String;
      --  Assemble directory path string

      Win  : Explorer_Window_Access :=
        Explorer_Window_Access (Get_Toplevel (Object));
      Arg1 : Gint := To_Gint (Params, 1);
      Arg2 : Gint := To_Gint (Params, 2);

      function Dir_Name (Old_Dir : String;
                         New_Dir : String) return String
      is
         --  Assemble directory path string
      begin
         if New_Dir = "." then
            return Old_Dir;
         end if;
         if New_Dir = ".." then
            declare
               Index : Integer := Old_Dir'Last;
            begin
               while Index > Old_Dir'First loop
                  if Old_Dir (Index) = Directory_Separator then
                     exit;
                  end if;
                  Index := Index - 1;
               end loop;
               if Index > Old_Dir'First then
                  if Index = Old_Dir'Last - 2
                    and then Old_Dir (Index .. Old_Dir'Last)
                             = Directory_Separator & ".."
                  then
                     return Old_Dir & Directory_Separator & "..";
                  else
                     return Old_Dir (Old_Dir'First .. Index - 1);
                  end if;
               end if;
            end;
         end if;
         return Old_Dir & Directory_Separator & New_Dir;
      end Dir_Name;

   begin
      if Arg2 = 0 or else Arg2 = 1 then
         declare
            Name : String := Get_Text (Object, Arg1, 0);
            Old_Dir : String := Win.Directory.all;
         begin
            if Is_Directory (Dir_Name (Old_Dir, Name)) then
               Free (Win.Directory);
               Win.Directory := new String' (Dir_Name (Old_Dir, Name));
               Fill (Win);
            end if;
         end;
      end if;
   end On_Clist_Select_Row;

   -------------------
   -- On_Ok_Clicked --
   -------------------

   procedure On_Ok_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
      --  Close explorer window
      Win : Explorer_Window_Access :=
        Explorer_Window_Access (Get_Toplevel (Object));
      use Gtk.Enums.Gint_List;

      List : Glist := Get_Selection (Win.Clist);

   begin
      Set_Text
        (Make_Harness_Window_Access (Win.Harness_Window).File_Name_Entry,
         Win.Directory.all &
           Directory_Separator &
           Get_Text (Win.Clist, Get_Data (List), 0));
      Hide_All (Get_Toplevel (Object));
   end On_Ok_Clicked;

   -----------------------
   -- On_Cancel_Clicked --
   -----------------------

   procedure On_Cancel_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Hide_All (Get_Toplevel (Object));
   end On_Cancel_Clicked;

end Explorer_Window_Pkg.Callbacks;