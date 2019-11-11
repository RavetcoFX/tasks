/*
* Copyright 2019 elementary, Inc. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

public class Tasks.TaskModel : GLib.Object {
    public TaskModel? snapshot { get; private set; }

    public string? uid { get; construct; }
    public string? rid { get; construct; }

    public string? summary;
    public string? description;
    public ICal.PropertyStatus? status;
    public GLib.DateTime? due;

    public TaskModel (string? uid, string? rid) {
        Object (uid: uid, rid: rid);
    }

    public void update_snapshot () {
        snapshot = new TaskModel(uid, rid);
        snapshot.summary = summary;
        snapshot.description = description;
        snapshot.status = status;
        snapshot.due = due;
    }

    public bool has_changed () {
        return snapshot != null && (
            uid != snapshot.uid ||
            summary != snapshot.summary ||
            description != snapshot.description ||
            status != snapshot.status ||
            due != snapshot.due
        );
    }

    public bool is_completed () {
        return status == ICal.PropertyStatus.COMPLETED;
    }

    public static GLib.DateTime? ical_time_to_glib_datetime (ICal.Time ical_time) {
        if (ical_time.is_null_time ()) {
            return null;
        }

        GLib.TimeZone glib_timezone = null;
        if (ical_time.get_tzid () != null) {
            glib_timezone = new GLib.TimeZone (ical_time.get_tzid ());
        } else {
            glib_timezone = new GLib.TimeZone.local ();
        }

        return new GLib.DateTime (
            glib_timezone,
            ical_time.year,
            ical_time.month,
            ical_time.day,
            ical_time.hour,
            ical_time.minute,
            ical_time.second
        );
    }
}
