open Tsdl
open Tgl4

let game_loop renderer =
    let event = Sdl.Event.create ()
    in
    let rec loop renderer = 
        let time_start = Sdl.get_ticks () in
        let should_loop =
        if Sdl.poll_event (Some event) then
            match Sdl.Event.(enum (get event typ)) with
            | `Quit -> false
            | `Key_down -> 
                    (
                        match Sdl.Event.(get event keyboard_scancode) |> Sdl.Scancode.enum with
                        | `Q -> false
                        | _ -> true
                    )
            | _ -> true
        else
            true
        in
        match Sdl.set_render_draw_color renderer 0 0 0 255 with
        | Error (`Msg error_message) -> Sdl.log "error %s" error_message; exit 1
        | Ok () -> ();
        match Sdl.render_clear renderer with
        | Error (`Msg error_message) -> Sdl.log "error %s" error_message; exit 1
        | Ok () -> ();
        Sdl.render_present renderer;
        let time_spent = Int32.sub (Sdl.get_ticks ()) time_start in
        if time_spent < 33l then Sdl.delay (Int32.sub 33l time_spent);
        if should_loop then loop renderer else ()
    in
    loop renderer


let () = match Sdl.init Sdl.Init.(video + events) with
| Error (`Msg error_message) -> Sdl.log "Init error %s" error_message; exit 1
| Ok () ->
        match Sdl.create_window ~w:640 ~h:480 "SDL OCaml" Sdl.Window.opengl with
        | Error (`Msg error_message) -> Sdl.log "Create window error %s" error_message; exit 1
        | Ok window ->
                match Sdl.create_renderer window with
                | Error (`Msg error_message) -> Sdl.log "Create renderer error %s" error_message; exit 1
                | Ok renderer ->
                        game_loop renderer;
                        Sdl.destroy_renderer renderer;
                        Sdl.destroy_window window;
                        Sdl.quit ();
                        Printf.fprintf stdout "hello %u %u" Gl.major_version Gl.minor_version;
                        exit 0;
