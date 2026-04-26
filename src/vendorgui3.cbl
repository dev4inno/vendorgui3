      * Build with: cobc --static -x `pkg-config --libs gtk+-3.0` vendorgui3.cbl
      * (--static is important, to overcome the 31 byte limit for called modules!)
      * take icons from Numix: /usr/share/icons/Numix/24/actions/
       identification division.
       program-id. vendorgui3.
       environment division.    
       configuration section.
       SPECIAL-NAMES. 
           CALL-CONVENTION 0 IS STANDARDC.   
       repository.
           function all intrinsic.    
            
       input-output section.

       file-control.
           select vendor
           assign               to dynamic ws-fname *>  "vendor"
           organization         is indexed
           access               is dynamic
           record key           is vendor-key
           alternate record key is vendor-key-s1 with duplicates
           lock mode            is manual  with lock on record
           sharing with all other    
           status               is file-status.        
       data division.

       file section.

       fd  vendor
           label record         is standard
           record contains 640  characters.

           copy "vendor.cbl".             

       working-storage section.

      *****************************************************************
      *    constants
      *****************************************************************
       01  constants.
           05  c-yes                      pic x      value "Y".
           05  c-no                       pic x      value "N".
           05  c-invalid                  pic x      value "I".
           05  c-locked                   pic x      value "L".
           05  c-end                      pic x      value "E".           
           05  c-enter-pressed            pic s9(10) value -0015925248.
           05  c-escape-pressed           pic s9(10) value -0015007744.
           05  c-tab-forward-pressed      pic s9(10) value -0016187392.
           05  c-ok-button-clicked        pic s9(10) value -0000000005.
           05  c-cancel-button-clicked    pic s9(10) value -0000000005.
.             
      *****************************************************************
      *    file control fields
      *****************************************************************
       77  ws-fname                        pic x(100) value 'vendor'.
       01  file-status.
           05  file-stat                   pic x(2).
               88  fs-ok-but-duplicate-key    value '02'.
               88  fs-eof                     value '10'.
               88  fs-inval-key-sequence      value '21'.
               88  fs-not-ok-duplicate-key    value '22'.
               88  fs-no-rec-found            value '23'.
               88  fs-boundary-violation      value '24'.
               88  fs-not-exists              value '35'.               
               88  fs-file-already-open       value '41'.
               88  fs-locked-rec              value '51'.
           05  file-status-keys redefines file-stat.
               10  status-key-1            pic x(1).
                   88  fs-status-ok           value '0'.
                   88  fs-at-end              value '1'.
                   88  fs-invalid-key-stat    value '2'.
                   88  fs-permanent-error     value '3'.
                   88  fs-locked-file         value '6'.  *> ???
                   88  fs-os-error            value '9'.
                                            
      ***************************************************************** 
       01 result               usage binary-long.
       01 result-boolean       usage binary-long sync.
       01 gtk-xmlfile          usage pointer.
       01 gtk-window-main      usage pointer.
       01 gtk-window-match     usage pointer.
       01 gtk-window-search    usage pointer.       
       01 gtk-about            usage pointer.
       01 gtk-builder          usage pointer. *> external.
       01 gtk-box              usage pointer.
       01 gtk-hello            usage pointer.
       01 gtk-textentry        usage pointer.
       01 gtk-message          usage pointer.       
       01 gtk-notebook         usage pointer.
       01 gtk-goodbye          usage pointer.
       01 gtk-dialog-term      usage pointer.
       01 gtk-dialog-search    usage pointer.
       01 gtk-liststore        usage pointer.
       01 gtk-style            usage pointer.
       01 gtk-model            usage pointer.
       01 gtk-iter             usage pointer.
       01 gtk-path             usage pointer.
       01 gtk-editable         usage pointer.
       01 gtk-renderer         usage pointer.
       01 gtk-treeview-match   usage pointer.
       01 gtk-context          usage pointer.
       01 gtk-curr-widget      usage pointer.
       01 gtk-widget-name      usage pointer.
       01 gdk-event-data       usage pointer.
       01 gtk-text             pic x(512).  *>        external.
       01 gtk-cssprovider      usage pointer.
       01 gtk-button           usage pointer.
       01 g-string             usage pointer.
       01 gtk-checkbutton      usage pointer.
       
       01 gtk-quit-callback    usage program-pointer.
       01 gtk-void-callback    usage program-pointer. 
      * 01 gdk-bitmask          usage BINARY-C-LONG. *> binary-long. 
       01 gdk-bitmask          usage BINARY-C-long unsigned.
       01 gdk-window           usage pointer.  
       01 gdk-screen           usage pointer. 
       
       01 css-priority         usage binary-long. *> unsigned sync.

       01 gtk-delete-callback  usage program-pointer.
       01 gtk-quit-handler-id  usage pointer.

      * results from treeview click
       01 treeview-dummy       usage pointer.   
       01 treeview-vennr       usage pointer.
       01 mac-vennr            pic x(8). 

       01 mac-cname           pic x(40) value space.

       01  gtk-tree-iter              based.
           05 gtk-tree-iter-stamp     binary-long signed sync.
           05 gtk-tree-iter-userdata  pointer sync.
           05 gtk-tree-iter-userdata2 pointer sync.
           05 gtk-tree-iter-userdata3 pointer sync.

       01  gtk-tree-iter-get          based.
           05 gtk-tree-iter-stamp     binary-long signed sync.
           05 gtk-tree-iter-userdata  pointer sync.
           05 gtk-tree-iter-userdata2 pointer sync.
           05 gtk-tree-iter-userdata3 pointer sync.
                  
       01 callback             usage procedure-pointer.
       01 params               usage pointer.
       01 xmlfile              pic x(9)  value z"test.xml". 
       01 rec-field            pic x(5).   
       01 rec-value            pic x(255).          
       01 scn-field            pic x(8).
       01 scn-value            pic x(255).
       01 conv-string          pic x(512).
       01 pageno               pic 99.
       01 vennr-x              pic x(8). 
       01 vennr-n redefines vennr-x pic 9(8). 
       01 vennr-len            pic 9.  
       01 vennr-offs           pic 9. 
       01 vendor-old           pic x(640).
       01 vendor-new           pic x(640).              
       01  wlanguage    pic x(16) value space.
       01  wusername    pic x(16) value space.  
       
       01  vennr-test                     pic x    value space.
           88  vendor-found               value "Y".
           88  vendor-not-found           value "N".
           88  vendor-number-invalid      value "I".
           88  vendor-locked              value "L".
           88  vendor-end                 value "E".
       01  match-test                     pic x    value space.
           88  match-yes                  value "Y".
           88  match-no                   value "N".
           88  match-end                  value "E".           
   
       01  input-test                     pic x    value space.
           88  input-ok                   value "Y".
           88  input-not-ok               value "N".
           
       01 zerostring              PIC X(01) VALUE x"00".
    
       01  first-flag.
           05  file-stat                   pic x(1).
               88  f-first        value ' '.

       01  dat-sys.
           05  jh                          pic 9(2).
           05  jj                          pic 9(2).
           05  mm                          pic 9(2).
           05  tt                          pic 9(2).
       01  bool-value                      pic 9.
      *****************************************************************
      *                                                               
      *    null record                                                
      *                                                               
      *****************************************************************
       01  null-record.
           05  filler                      pic x(048) value all x"00".
           05  filler                      pic x(538) value spaces.
           05  null-vennr-x                pic x(008) value spaces.          
           05  null-vennr redefines null-vennr-x  pic 9(008).
           05  filler                      pic x(046) value spaces.                 
      *****************************************************************
       01  meld-tab.  
      * Message 1 
           05  FILLER                      PIC X(60)
               VALUE "Please enter a vendor number
      -    "          ".
      * Message 2 
           05  FILLER                      PIC X(60)
               VALUE "Vendor does not exist
      -    "          ".
      * Message 3 
           05  FILLER                      PIC X(60)
               VALUE "Vendor will be displayed in next screen
      -    "          ".
      * Message 4 
           05  FILLER                      PIC X(60)
               VALUE "Option to be added
      -    "          ".
      * Message 5 
           05  FILLER                      PIC X(60)
               VALUE "File vendor could not be opened - Program terminat 
      -    "ed        ".
      * Message 6
      * §§§ Number of vendor !!!! 
           05  FILLER                      PIC X(60)
               VALUE "Vendor is locked by another user
      -    "          ".
      * Message 7 
           05  FILLER                      PIC X(60)
               VALUE "New Vendor
      -    "          ".
      * Message 8 
           05  FILLER                      PIC X(60)
               VALUE "Wrong key pressed
      -    "          ".
      * Message 9 
           05  FILLER.
               10  FILLER                  PIC X(34)
                   VALUE "Record saved with Vendor Number.. ".
               10  MELD9-VENNR             PIC 9(08).
               10  FILLER                  PIC X(18) VALUE SPACES. 
      * Message 10 
           05  FILLER                      PIC X(60)
               VALUE "This field is mandatory
      -    "          ".
      * Message 11 
           05  FILLER                      PIC X(60)
               VALUE "This field is mandatory
      -    "          ".      
      * Message 12 
           05  FILLER                      PIC X(60)
               VALUE "No vendor selected 
      -    "          ".      
      * Message 13 
           05  FILLER                      PIC X(60)
               VALUE "No vendor found for given name
      -    "          ".      
      * Message 14 
           05  FILLER                      PIC X(60)
               VALUE "Invalid selection
      -    "          ".  
      * Message 15 
           05  FILLER.
               10  FILLER                  PIC X(38)
                   VALUE "Update error file vendor - error code ".
               10  MELD-FSTAT              PIC XX.
               10  FILLER                  PIC X(20) VALUE SPACES.                 
      * Message 16 
           05  FILLER                      PIC X(60)
               VALUE "Only 'X' or Blank allowed
      -    "          ".   
       01  filler redefines meld-tab.
           05  meldung                     pic x(60)
               occurs 16 indexed by meld-ind.

           copy "vendor.ini".
                      
      *****************************************************************
      *    iconv fields
      *****************************************************************
       01 codepage-gtk.
          05 value z"UTF-8".
       01 codepage-local.
          05 value z"ISO8859-15".  *> change as needed
      *>    05 value z"UTF-8".     *> change as needed     
       01 iconv-hndl usage pointer.
       01 iconv-retc redefines iconv-hndl usage binary-c-long.
       01 inlen usage binary-c-long.
       01 outlen usage binary-c-long.
       01 retc usage binary-c-long.
       01 field-rec-ptr usage pointer.
       01 field-gtk-ptr usage pointer.
       01 field-rec pic x(255).
       01 field-gtk pic x(255).



       linkage section.

       01 gdk-event            usage pointer. 
          05 filler            usage binary-short.     
          05 filler            usage pointer.     
          05 filler            usage binary-short.     
          05 filler            usage binary-long.     
          05 filler            usage binary-short.     
          05 filler            usage binary-long. 
          05 filler            usage binary-long.           
          05 gdk-event-keycode usage binary-long.
           
       01 gtk-win              usage pointer.
       01 gtk-dat              usage pointer.             
       01 gtk-ret              usage pointer.             
       01 gtk-bld              usage pointer. 
       01 gtk-textfield        pic x(40) VALUE SPACE. 
       01 gtk-treeview         usage pointer.
       01 gtk-treepath         usage pointer.
       01 gtk-treecol          usage pointer.
       01 gtk-treeiter-get     usage pointer.
       01 gtk-boolean          usage pointer.

       procedure division.
      ******************************************************************
      *    Main program
      ******************************************************************

        accept wusername from user name end-accept
        accept wlanguage from environment "LANG" end-accept
        accept dat-sys   from date yyyymmdd
      * open the file      
           open i-o sharing with all other vendor
          
           if not fs-status-ok 
              if fs-not-exists      
                 open output vendor
                 close vendor
                 open i-o  sharing with all other vendor
      *          if not fs-status-ok
      *              move meldung (5) to vendor1-meldg 
      *              display vendor1  
      *              display vendor1-meldg at 2211
      *                foreground-color is cob-color-yellow highlight  
      *              move ende to prog-test                   
      *           end-if
      *        else
      *           move meldung (5) to vendor1-meldg 
      *           display vendor1  
      *           display vendor1-meldg at 2211
      *           foreground-color is cob-color-yellow highlight                                
      *           move ende to prog-test
      *        end-if
           end-if.      


         move space to first-flag
         
      * init Gtk            
          call "gtk_init_check" using
              by value 0
              by reference null
              returning result
           end-call
           
           if result not equal 1  *> 1: TRUE
              display 
                "Gtk could not be initialized - Program terminated" 
              end-display
              stop run
           end-if 
           
      * load the glade file with the screen layout
           call "gtk_builder_new_from_file " using
             by content z"vendorgui3.glade"
             returning gtk-builder             
           end-call
          
      * get reference to main windows                
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"winmain"
              returning gtk-window-main
           end-call

      * get reference to about dialog                
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"dlgabout"
              returning gtk-about
           end-call

      * get reference to search dialog                
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"dlgsearch"
              returning gtk-dialog-search
           end-call           
                     
      * get reference to the message field
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"lblmessage"
              returning gtk-message
           end-call
           
      * get reference to the notebook containing sub screens      
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"notebook"
              returning gtk-notebook
           end-call

      * get reference to search windows                
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"winsearch"
              returning gtk-window-search
           end-call


      * get reference to matchcode windows                
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"winmatchcode"
              returning gtk-window-match
           end-call
           
      * get reference to treeview for vendor matchcode    
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"treematchcode"
              returning gtk-treeview-match
           end-call           

      * get reference to liststore for vendor matchcode    
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"lstmatchcode"
              returning gtk-liststore
           end-call     
           
      * get reference to checkbutton for deletion flag    
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"chkDFLAG"
              returning gtk-checkbutton
           end-call     

           call "gtk_css_provider_new" 
              returning  gtk-cssprovider
           end-call     
           
           call "gtk_css_provider_load_from_path" using
              by value gtk-cssprovider
              by content z"guistyle.css"
              by reference null
      *        returning result
           end-call     
           
           
           call "gdk_screen_get_default" 
              returning  gdk-screen
           end-call  
           

           move 600 to css-priority
        
      *          ....+....1....+....2....+....3....+....4. 
           call "gtk_style_context_add_provider_for_screen" using
              by value gdk-screen
              by value gtk-cssprovider
              by value css-priority    *>content css-priority
           end-call    

           call "gtk_window_set_transient_for" using
              by value gtk-window-search
              by value gtk-window-main
           end-call   
      
           call "gtk_window_set_transient_for" using
              by value gtk-window-match
              by value gtk-window-main
           end-call       
         
      * connect the signals (callbacks)
           call "gtk_builder_connect_signals" using
              by value gtk-builder
              by reference null
           end-call



      *> !!! IMPORTANT: This call prevents the window from being destroyed !!!        
       set gtk-delete-callback to entry "gtk_widget_hide_on_delete"
       
       call "g_signal_connect_data" using
           by value gtk-window-main
           by reference z"delete_event"        *> with inline Z string
           by value gtk-delete-callback          *> function call back pointer
           by value 0                          *> pointer to data
           by value 0                          *> closure notify to manage data
           by value 0                          *> connect before or after flag
           returning gtk-quit-handler-id       *> not used in this sample
       end-call       
       
       call "g_signal_connect_data" using
           by value gtk-window-match
           by reference z"delete_event"        *> with inline Z string
           by value gtk-delete-callback          *> function call back pointer
           by value 0                          *> pointer to data
           by value 0                          *> closure notify to manage data
           by value 0                          *> connect before or after flag
           returning gtk-quit-handler-id       *> not used in this sample
       end-call

       call "g_signal_connect_data" using
           by value gtk-window-search
           by reference z"delete_event"        *> with inline Z string
           by value gtk-delete-callback          *> function call back pointer
           by value 0                          *> pointer to data
           by value 0                          *> closure notify to manage data
           by value 0                          *> connect before or after flag
           returning gtk-quit-handler-id       *> not used in this sample
       end-call

      * set screen size
           call "gtk_window_set_default_size" using
              by value gtk-window-main
              by value 970                
              by value 420              
           end-call.

      * show the screen
           call "gtk_widget_show_all" using
              by value gtk-window-main
           end-call.

          call "gtk_events_pending"
              returning result
          end-call
          
          perform do-events thru do-events-exit
            until result equal 0
   
      * start the processing
           call "gtk_main" 
           end-call.
          
      * Something terminated the GTK main loop: wrap up
           close vendor.

           goback.
      *    end program.            


      ******************************************************************
      ******************************************************************
      ********************* CALLBACKS **********************************
      ******************************************************************
      ******************************************************************

      *-----------------------------------------------------
       ENTRY STANDARDC "on_mnuquit_activate" USING 
           by value gtk-win by value gtk-dat.
      *     call "gtk_main_quit" 
      *     end-call
           perform ask-for-terminate thru
                   ask-for-terminate-exit   
       goback.          
      
      *-----------------------------------------------------
       ENTRY STANDARDC "on_main_delete_event" USING 
           by value gtk-win by value gtk-dat.
      *     call "gtk_main_quit" 
      *     end-call
           perform ask-for-terminate thru
                   ask-for-terminate-exit   
       goback.          

      *-----------------------------------------------------
       ENTRY STANDARDC "on_btnquit_clicked" USING 
           by value gtk-win by value gtk-dat.
      *     call "gtk_main_quit" 
      *     end-call
           perform ask-for-terminate thru
                   ask-for-terminate-exit   
       goback.

       ENTRY STANDARDC "on_main_key_press_event" USING 
           by value gtk-win 
           by content gdk-event
           by value gtk-dat.
           

           if gdk-event-keycode equal c-enter-pressed 
              perform process-input thru
                      process-input-exit                   
           end-if
           
           if gdk-event-keycode equal c-escape-pressed 
              if pageno equal 0
                 perform ask-for-terminate thru
                         ask-for-terminate-exit  
              else 
                  if ve-dflag equal 'N'
                     delete vendor
                  end-if                
                  unlock vendor record
                  move 0 to pageno 
                  perform reset-vennr thru
                          reset-vennr-exit
                  call "gtk_notebook_set_current_page" using
                     by value gtk-notebook
                     by value pageno   *>1
                  end-call

                    call "gtk_label_set_text" using
                       by value gtk-message
                       by content 
                          z" "
                    end-call  
      * on first page set focus to field vendor number
                  call "gtk_builder_get_object" using
                     by value gtk-builder
                     by content z"entVENNR"
                     returning gtk-textentry
                  end-call
                  call "gtk_widget_grab_focus" using
                     by value gtk-textentry
                  end-call                             
                                                     
              end-if                       
           end-if
           
      
       goback.
     
      *-----------------------------------------------------
       ENTRY STANDARDC "on_btnenter_clicked" USING 
           by value gtk-win by value gtk-dat.

              perform process-input thru
                      process-input-exit             
           
            continue.
        
       goback.       
       
       ENTRY STANDARDC "on_mnuinfo_activate" USING 
           by value gtk-win by value gtk-dat.

              call "gtk_window_set_transient_for" using
                  by value gtk-about
                  by value gtk-window-main
               end-call           
  
              call "gtk_dialog_run" using
                  by value gtk-about
                  returning result
               end-call           
               call "gtk_widget_hide" using
                  by value gtk-about
               end-call   
           
           
            continue.
        
       goback.     
       
 
       ENTRY STANDARDC "on_dlgAbout_close" USING 
           by value gtk-win by value gtk-dat.


            continue.
        
       goback.    
       
       ENTRY STANDARDC "on_btnsearch_clicked" USING 
           by value gtk-win by value gtk-dat.
       
              perform search-vendor thru
                      search-vendor-exit           
       
            continue.
        
       goback.  
             
       ENTRY STANDARDC "on_btnsrcenter_clicked" USING 
           by value gtk-win by value gtk-dat.

              perform vendor-matchcode thru
                      vendor-matchcode-exit           

            continue.
        
       goback.    

       ENTRY STANDARDC "on_btnsrcexit_clicked" USING 
           by value gtk-win by value gtk-dat.

      * Initialize search field 
      
           call "gtk_widget_hide" using
              by value gtk-window-search
           end-call   
               
           continue.
        
       goback. 

       ENTRY STANDARDC "on_treematchcode_row_activated" USING 
           by value gtk-treeview 
           by value gtk-treepath 
           by value gtk-treecol  
           by value gtk-dat.


           SET ADDRESS OF gtk-tree-iter-get TO gtk-iter
 
           call "gtk_tree_model_get_iter" using
              by value gtk-liststore *>gtk-model 
              by reference gtk-iter *>reference gtk-iter  *> gtk-tree-iter
              by value gtk-treepath
              returning result
           end-call  

           call "gtk_tree_model_get" using
              by value gtk-liststore
              by reference gtk-iter 
              by value 0             
              by reference treeview-dummy 
              by value 1
              by reference treeview-vennr 
              by value -1                         
           end-call    
           
           move trim(content-of(treeview-vennr)) to mac-vennr    
           
            call "gtk_widget_hide" using
               by value  gtk-window-match
            end-call   

              perform process-input thru
                      process-input-exit   
           
           continue.
        
       goback. 
       
       ENTRY STANDARDC "on_winmatchcode_delete_event" USING 
            by value gtk-win by value gtk-dat.

            call "gtk_widget_hide" using
               by value gtk-window-match
            end-call   

           move 1 to result-boolean.
           
           continue.
      *
       goback returning result-boolean.            
       


       ENTRY STANDARDC "on_btnmcback_clicked" USING 
            by value gtk-win by value gtk-dat.

            call "gtk_widget_hide" using
               by value  gtk-window-match
            end-call   
                                
           continue.

       goback.              

       ENTRY STANDARDC "on_winsearch_delete_event" USING 
            by value gtk-win by value gtk-dat.

            call "gtk_widget_hide" using
               by value  gtk-window-search
            end-call   
                     
              
           continue.

       goback.              


       ENTRY STANDARDC "on_winmain_delete_event" USING 
           by value gtk-win by value gtk-dat.
           
           perform ask-for-terminate thru
                   ask-for-terminate-exit              
        
      *    show the screen
           call "gtk_widget_show_all" using
              by value gtk-window-main
           end-call                       
              
           continue.

       goback.    
          
                               
      ******************************************************************
      ******************************************************************
      ********************* PERFORMS  **********************************
      ******************************************************************
      ******************************************************************

       process-input.
      ******************************************************************                                                               
      *    process the input                                  
      ******************************************************************       

           call "gtk_label_set_text" using
              by value gtk-message
              by content z" " 
           end-call
       
           if pageno equal 0
              perform check-vennr thru
                      check-vennr-exit  
           
              if vendor-found
                 move 1 to pageno
                  perform rec-to-scn thru
                          rec-to-scn-exit                  
              else
                 if vendor-number-invalid
                    call "gtk_label_set_text" using
                       by value gtk-message
                       by content 
                          z"Invalid vendor number - must be numeric"
                    end-call  
                 else
                    if vendor-not-found
                       if ve-vennr equal zero
                          perform get-next-vennr thru
                                  get-next-vennr-exit
                          move vendor-record-i  to vendor-record
                          move null-vennr      to ve-vennr
                          move "N"             to ve-dflag
                          move wusername       to ve-cuser
                          move dat-sys         to ve-cdate                 
                          write vendor-record 
                         read vendor with lock                       
                          move 1               to pageno
                          perform rec-to-scn thru
                                  rec-to-scn-exit                             
                          call "gtk_label_set_text" using
                             by value gtk-message
                             by content z"New vendor"
                          end-call
                       else
                          move ve-vennr        to null-vennr
                          move vendor-record-i to vendor-record
                          move null-vennr      to ve-vennr  
                          move "N"             to ve-dflag
                          move wusername       to ve-cuser
                          move dat-sys         to ve-cdate                 
                          write vendor-record 
                          read vendor with lock                       
                          move 1               to pageno
                          perform rec-to-scn thru
                                  rec-to-scn-exit                             
                          call "gtk_label_set_text" using
                             by value gtk-message
                             by content z"New vendor"
                          end-call
                       end-if                                            

                    else
                       if vendor-locked
      *                   display ve-ccity end-display
                          call "gtk_label_set_text" using
                             by value gtk-message
                             by content 
                          z"Vendor locked by other user - display-only"
                          end-call
                          move 1 to pageno
                          perform rec-to-scn thru
                                  rec-to-scn-exit                          
                       end-if   
                    end-if 
                 end-if    
              end-if
           else
      *  
              perform scn-to-rec thru
                      scn-to-rec-exit  
                      
              perform check-input thru
                      check-input-exit
                      
              if input-ok then          
                 if not vendor-locked then
                    move vendor-record to vendor-new
                    if vendor-old not equal vendor-new then                      
                       move wusername        to  ve-uuser
                       move dat-sys          to  ve-udate           
                       rewrite vendor-record
                    
                       call "gtk_label_set_text" using
                          by value gtk-message
                          by content 
                          concatenate("Vendor " ve-vennr " saved" x"00") 
                       end-call                    
                    end-if   
                   end-if    
            
                 unlock vendor record
                 move 0 to pageno 
                perform reset-vennr thru
                         reset-vennr-exit
              end-if                     
           end-if
           call "gtk_notebook_set_current_page" using
              by value gtk-notebook
              by value pageno   *>1
           end-call

      * on first page set focus to field vendor number
           if pageno equal 0
              call "gtk_builder_get_object" using
                 by value gtk-builder
                 by content z"entVENNR"
                 returning gtk-textentry
              end-call
              call "gtk_widget_grab_focus" using
                 by value gtk-textentry
              end-call
           else   
              call "gtk_builder_get_object" using
                 by value gtk-builder
                 by content z"entCNAME"
                 returning gtk-textentry
              end-call
              call "gtk_widget_grab_focus" using
                 by value gtk-textentry
              end-call              
           end-if
       
         continue.
       
       process-input-exit.
           exit.

       check-input. 
      ******************************************************************                                                               
      *    check the screen input                                     
      ******************************************************************       

         move c-yes  to input-test

         if ve-cname equal spaces
            move c-no to input-test
            call "gtk_label_set_text" using
               by value gtk-message
               by content z"This field is mandatory "
            end-call              
            call "gtk_builder_get_object" using
               by value gtk-builder
               by content z"entCNAME"
               returning gtk-textentry
            end-call
            call "gtk_widget_grab_focus" using
               by value gtk-textentry
            end-call                             
         end-if                   


         continue.
                
       check-input-exit.
           exit.
           
       check-vennr.
      ******************************************************************                                                               
      *    check the vendor number                                       
      ******************************************************************
           
           if mac-vennr equal spaces
           
              call "gtk_builder_get_object" using
                 by value gtk-builder
                 by content z"entVENNR"
                 returning gtk-textentry
              end-call

              call "gtk_entry_get_text" using
                 by value gtk-textentry
                 returning gtk-dat
              end-call 
           
           
      *       SET gtk-dat TO ADDRESS OF vennr-x
              move content-of(gtk-dat)           to vennr-x
              move LENGTH(content-of(gtk-dat))   to vennr-len       
                  
           else 
           
              move mac-vennr                     to vennr-x
              move LENGTH(mac-vennr)             to vennr-len 
              move spaces                        to mac-vennr        
          
           end-if
           

           subtract vennr-len from 9 giving vennr-offs.

      *    fill the vendor key correctly     
           move zero to ve-vennr.
           move vennr-x(1:vennr-len) to ve-vennr(vennr-offs:vennr-len).
           
            IF vennr-x(1:vennr-len) IS NUMERIC
               read vendor with lock
               move vendor-record to vendor-old
               move vendor-record to vendor-new
               if fs-status-ok and not fs-locked-rec and
                   not fs-locked-file
                   move c-yes                  to vennr-test
               else
                   move c-no                   to vennr-test
                   if fs-locked-rec 
                      move c-locked            to vennr-test
      * read vendor anyways only to display the data                      
                      read vendor with ignore lock    
                   end-if
               end-if
            else
              move c-invalid to vennr-test                  
            end-if

            continue.
       
       check-vennr-exit.
           exit. 


       reset-vennr.
      ******************************************************************                                                               
      *    reset the vendor number                                       
      ******************************************************************
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"entVENNR"
              returning gtk-textentry
           end-call


           call "gtk_entry_set_text" using
              by value gtk-textentry
              by content zerostring
           end-call 
           
           continue.
           
       reset-vennr-exit.
      
           exit.    


       search-vendor.
      ******************************************************************                                                               
      *    search for vendors                                      
      ****************************************************************** 

      * show the screen
      
      *     call "gtk_window_set_transient_for" using
      *         by value gtk-window-search
      *         by value gtk-window-main
      *     end-call   
                     
           call "gtk_widget_show_all" using
              by value gtk-window-search
           end-call.

                               
           continue.
       search-vendor-exit.    
           exit.    
          

       ask-for-terminate.
      ******************************************************************                                                               
      *    ask if program should be terminated
      ******************************************************************
      
              call "gtk_message_dialog_new" using
                  by value gtk-window-main  
                  by value 0  *> dialog modal
                  by value 2  *> message question
                  by value 5  *> buttons OK & Cancel
                  by content z"Do you want to end the application?" 
                  returning gtk-dialog-term
               end-call    
               call "gtk_window_set_title" using
                  by value gtk-dialog-term
                  by content z"Question"
               end-call  
 
                     
              call "gtk_widget_get_style_context" using
                  by value gtk-dialog-term
                  returning gtk-context
              end-call            
              call "gtk_style_context_add_class" using
                  by value gtk-context
                  by content z"backing" 
              end-call                  
       
               call "gtk_dialog_run" using
                  by value gtk-dialog-term
                  returning result
               end-call           
               call "gtk_widget_destroy" using
                  by value gtk-dialog-term
               end-call           
      *        display result end-display
               if result equal c-ok-button-clicked
                  if ve-dflag = "N" then
                     delete vendor
                  end-if
                  call "gtk_main_quit" 
                  end-call
               end-if     
                     
           continue.
           
       ask-for-terminate-exit.
           exit.  

           
       rec-to-scn.
      ******************************************************************
      *    fill screen fields from record 
      ******************************************************************
      
      * VENNR
           move ve-vennr  to scn-value
           move "VENNO"   to rec-field
           perform fill-scn thru
                   fill-scn-exit         
      * UDATE
      *     move ve-udate  to scn-value
           move locale-date(ve-udate)  to scn-value           
           move "UDATE"   to rec-field
           perform fill-scn thru
                   fill-scn-exit         
      * UUSER
           move ve-uuser  to scn-value
           move "UUSER"   to rec-field
           perform fill-scn thru
                   fill-scn-exit         
      
      * CNAME
           move ve-cname  to scn-value
           move "CNAME"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * LNAME   
           move ve-lname  to scn-value
           move "LNAME"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * FNAME  
           move ve-fname  to scn-value
           move "FNAME"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * PCODE     
           move ve-pcode  to scn-value
           move "PCODE"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * CCITY  
           move ve-ccity  to scn-value
           move "CCITY"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * STRNO  
           move ve-strno  to scn-value
           move "STRNO"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * AINFO
           move ve-ainfo  to scn-value
           move "AINFO"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * CNTRY 
           move ve-cntry  to scn-value
           move "CNTRY"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * PHONE                
           move ve-phone  to scn-value
           move "PHONE"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * EMAIL
           move ve-email  to scn-value
           move "EMAIL"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * STATE 
           move ve-state  to scn-value
           move "STATE"   to rec-field
           perform fill-scn thru
                   fill-scn-exit      
      * BNAME
           move ve-bname  to scn-value
           move "BNAME"   to rec-field
           perform fill-scn thru
                   fill-scn-exit
      * SWIFT
           move ve-swift  to scn-value
           move "SWIFT"   to rec-field
           perform fill-scn thru
                   fill-scn-exit
      * ACCNT
           move ve-accnt  to scn-value
           move "ACCNT"   to rec-field
           perform fill-scn thru
                   fill-scn-exit
      * BCITY
           move ve-bcity  to scn-value
           move "BCITY"   to rec-field
           perform fill-scn thru
                   fill-scn-exit
      * REM01
           move ve-rem01  to scn-value
           move "REM01"   to rec-field
           perform fill-scn thru
                   fill-scn-exit                  
      * REM02
           move ve-rem02  to scn-value
           move "REM02"   to rec-field
           perform fill-scn thru
                   fill-scn-exit                     

      * DFLAG
           if ve-dflag not equal "N"           
              if ve-dflag = "X" then
                 move 1 to bool-value
              else
                 move 0 to bool-value
              end-if
           
      * gtkcheckbutton is a subclass of gtktogglebutton
              call "gtk_toggle_button_set_active" using
                 by value gtk-checkbutton
                 by value bool-value   
              end-call 
           end-if
           
           call "gtk_main_iteration"
           end-call
                         
           continue.
      
       rec-to-scn-exit.            
           exit. 
           

       fill-scn.
      ******************************************************************
      *    Fill the screen fields
      ******************************************************************          
            if codepage-gtk not equal codepage-local      
              move scn-value to field-rec
              perform iconv-to-gtk thru
                      iconv-to-gtk-exit            
              move field-gtk to scn-value
           end-if    
           move concatenate ("ent", rec-field) to scn-field  
      *   display "scn-field: " scn-field end-display
           call "gtk_builder_get_object" using
              by value   gtk-builder
              by content concatenate(trim(scn-field) x"00")   *>content z"ent" && scn-field
              returning gtk-textentry
           end-call
           call "gtk_entry_set_text" using
              by value gtk-textentry
              by content concatenate(trim(scn-value) x"00") 
           end-call     
           perform decide-disp-edit thru decide-disp-edit-exit   

           continue.
             
       fill-scn-exit.
           exit. 
       
       scn-to-rec.
      ******************************************************************
      *    fill record fields from screen 
      ******************************************************************       
      * CNAME
           move "CNAME"   to rec-field
           perform fill-rec thru
                   fill-rec-exit  
           move rec-value to ve-cname                       
      * LNAME   
           move "LNAME"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-lname 
      * FNAME  
           move "FNAME"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-fname 
      * PCODE     
           move "PCODE"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-pcode 
      * CCITY  
           move "CCITY"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-ccity 
      * STRNO  
           move "STRNO"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-strno 
      * AINFO
           move "AINFO"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-ainfo 
      * CNTRY 
           move "CNTRY"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-cntry 
      * PHONE                
           move "PHONE"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-phone 
      * EMAIL
           move "EMAIL"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-email 
      * STATE 
           move "STATE"   to rec-field
           perform fill-rec thru
                   fill-rec-exit      
           move rec-value to ve-state 
      * BNAME
           move "BNAME"   to rec-field
           perform fill-rec thru
                   fill-rec-exit
           move rec-value to ve-bname 
      * SWIFT
           move "SWIFT"   to rec-field
           perform fill-rec thru
                   fill-rec-exit
           move rec-value to ve-swift 
      * ACCNT
           move "ACCNT"   to rec-field
           perform fill-rec thru
                   fill-rec-exit
           move rec-value to ve-accnt 
      * BCITY
           move "BCITY"   to rec-field
           perform fill-rec thru
                   fill-rec-exit
           move rec-value to ve-bcity 
      * REM01
           move "REM01"   to rec-field
           perform fill-rec thru
                   fill-rec-exit                  
           move rec-value to ve-rem01 
      * REM02
           move "REM02"   to rec-field
           perform fill-rec thru
                   fill-rec-exit                     
           move rec-value to ve-rem02 
      * DFLAG
      
      *     if ve-dflag not equal "N"
      *       gtkcheckbutton is a subclass of gtktogglebutton
              call "gtk_toggle_button_get_active" using
                 by value gtk-checkbutton
                 returning bool-value   
              end-call 
              if bool-value = 0
                 move space to ve-dflag
              else 
                 move "X"   to ve-dflag
              end-if
      *     end-if   
             
                   
           call "gtk_main_iteration"
           end-call           
                                       
           continue.
      
       scn-to-rec-exit.            
           exit.          
             
       fill-rec.
      ******************************************************************
      *    fill record fields from screen 
      ******************************************************************

           move concatenate ("ent", rec-field) to scn-field  
           call "gtk_builder_get_object" using
              by value   gtk-builder
              by content concatenate(trim(scn-field) x"00")   *>content z"ent" && scn-field
              returning gtk-textentry
           end-call
 
           call "gtk_entry_get_text" using
              by value gtk-textentry
              returning gtk-dat
           end-call 

           move content-of(gtk-dat) to rec-value.
           
           if codepage-gtk not equal codepage-local      
              move content-of(gtk-dat) to field-gtk
              perform iconv-to-local thru
                      iconv-to-local-exit            
              move field-rec to rec-value
           end-if    

           continue.
           
       fill-rec-exit.
           exit.           

       decide-disp-edit.  
      ******************************************************************
      *    Decide if field shall be editable or display only (if locked)
      ******************************************************************                 
      
          if vendor-locked
             call "gtk_widget_set_sensitive" using
                by value gtk-textentry
                by value 0
             end-call       
           else
             call "gtk_widget_set_sensitive" using
                by value gtk-textentry
                by value 1
             end-call                               
           end-if

           continue.
                        
       decide-disp-edit-exit.            
           exit.            
           
           
       vendor-matchcode.
      ******************************************************************
      *    Prepare the vendor matchcode display
      ******************************************************************     
           move space to mac-vennr
           
           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"entmacCNAME"
              returning gtk-textentry
           end-call
   
           call "gtk_entry_get_text" using
              by value gtk-textentry
              returning gtk-dat
           end-call 
           
           move space to mac-cname
           move trim(content-of(gtk-dat))  to mac-cname

           call "gtk_window_set_transient_for" using
               by value gtk-window-match
               by value gtk-window-main
            end-call       


           call "gtk_widget_hide" using
              by value gtk-window-search
           end-call             
       
           call "gtk_main_iteration" 
              returning omitted
           end-call                

           move 'X' to first-flag
           SET ADDRESS OF gtk-tree-iter TO gtk-iter
          
            
           call "gtk_list_store_clear" using
               by value gtk-liststore
                             returning omitted
            end-call                  


          move space to vennr-test
          move mac-cname to vendor-key-s1
          start vendor key is not less than vendor-key-s1
           if not fs-status-ok
              move c-no                  to match-test
              move c-end                 to vennr-test
           else
              perform read-mac thru
                      read-mac-exit
                      until vendor-end
           end-if

           call "gtk_builder_get_object" using
              by value gtk-builder
              by content z"entmacCNAME"
              returning gtk-textentry
           end-call

           call "gtk_entry_set_text" using
              by value gtk-textentry
              by content zerostring
           end-call 

          call "gtk_events_pending"
              returning result
          end-call
          
          perform do-events thru do-events-exit
            until result equal 0
 
      *    show the screen
           call "gtk_widget_show_all" using
              by value gtk-window-match
           end-call  
         

          call "gtk_events_pending"
              returning result
          end-call
          
          perform do-events thru do-events-exit
            until result equal 0
      
           continue.

       vendor-matchcode-exit.
             exit.            
           
       read-mac.
      *****************************************************************
      *                                                               *
      *    read vendor file and fill matchcode table
      *                                                               *
      *****************************************************************


           read vendor next record with ignore lock  

           if not fs-status-ok
              if not fs-locked-rec
                 if fs-eof
                    move c-end              to vennr-test
                 end-if
              else
                 start vendor key is greater than vendor-key-s1
              end-if
           end-if

           if ve-dflag not equal "N" and not vendor-end
           
              call "gtk_list_store_append" using
                 by value gtk-liststore
                 by reference gtk-iter *> gtk-tree-iter
                 returning omitted
              end-call       
              if codepage-gtk not equal codepage-local      
                 move ve-cname to field-rec
                 perform iconv-to-gtk thru
                         iconv-to-gtk-exit            
                 move field-gtk to ve-cname
              end-if        
              call "gtk_list_store_set" using
                 by value gtk-liststore
                 by reference gtk-iter *>gtk-tree-iter *>0  *>iter
                 by value 0  
                 by content concatenate(trim(ve-cname) x"00")
                 by value 1
                 by content concatenate(trim(ve-vennr) x"00")
                 by value -1                         
              end-call             
           end-if
           
           unlock vendor record.

       read-mac-exit.
           exit.
           
          
       do-events. 
      *****************************************************************
      *                                                               *
      *    gtk interrupt
      *                                                               *
      *****************************************************************
           call "gtk_main_iteration" 
              returning omitted
           end-call    
                     
          call "gtk_events_pending"
              returning result
          end-call
         
          continue.
              
       do-events-exit.
            exit.   
           
       iconv-to-gtk.              
      *****************************************************************
      *                                                               *
      *    convert value from local codepage to gtk (utf-8)
      *                                                               *
      *****************************************************************

         move space to field-gtk
      *> Convert from local codepage to utf-8 (gtk)
      *> CALL SYNOPSIS in C convention:
      *> iconv_t iconv_open(const char *tocode, const char *fromcode);
          call "iconv_open" using
            codepage-gtk codepage-local
            returning iconv-hndl
           on exception
              display "error: no iconv_open" upon syserr end-display
          end-call
          if iconv-retc equal -1 then
             display "error: iconv_open failed" upon syserr end-display
          end-if

          set field-rec-ptr to address of field-rec
          set field-gtk-ptr to address of field-gtk

          move length(FUNCTION TRIM(field-rec TRAILING)) to inlen
          move length(field-gtk) to outlen

          call "iconv" using
              by value iconv-hndl
              by reference field-rec-ptr inlen
              by reference field-gtk-ptr outlen
              returning retc
          end-call
         if retc equal -1 then
            display "error: iconv conversion failed" upon syserr
         end-if

         call "iconv_close" using
            by value iconv-hndl
         end-call
         continue.
                   
       iconv-to-gtk-exit.
            exit.   
           
       iconv-to-local.              
      *****************************************************************
      *                                                               *
      *    convert value from gtk (utf-8) to local codepage
      *                                                               *
      *****************************************************************

         move space to field-rec
      *> Convert from local codepage to utf-8 (gtk)
      *> CALL SYNOPSIS in C convention:
      *> iconv_t iconv_open(const char *tocode, const char *fromcode);
          call "iconv_open" using
            codepage-local codepage-gtk
            returning iconv-hndl
           on exception
              display "error: no iconv_open" upon syserr end-display
          end-call
          if iconv-retc equal -1 then
             display "error: iconv_open failed" upon syserr end-display
          end-if

          set field-rec-ptr to address of field-rec
          set field-gtk-ptr to address of field-gtk

          move length(FUNCTION TRIM(field-gtk TRAILING)) to inlen
          move length(field-rec) to outlen

          call "iconv" using
              by value iconv-hndl
              by reference field-gtk-ptr inlen
              by reference field-rec-ptr outlen
              returning retc
          end-call
         if retc equal -1 then
            display "error: iconv conversion failed" upon syserr
         end-if

         call "iconv_close" using
            by value iconv-hndl
         end-call
         continue.
                   
       iconv-to-local-exit.
            exit.              
           
       get-next-vennr.
      *****************************************************************
      *                                                               *
      *    determine the next free vendor number to be used 
      *                                                               *
      *****************************************************************
           
           move null-record            to vendor-record
           read vendor with ignore lock
           move vendor-record          to null-record

           if null-vennr not numeric or null-vennr equal zero
              move 1                   to null-vennr
           end-if   

      * check if vendor already exists, if yes: increment vendor no.
           move null-vennr             to ve-vennr 
           read vendor  with ignore lock
           if fs-status-ok or fs-locked-rec 
              add 1                    to null-vennr
      *       check for older incomplete temporary and unlocked record  
      *       if found: delete it to free the number!        
              if  ve-cdate less than dat-sys and ve-dflag equal "N"
                  and fs-status-ok
                  delete vendor record
              end-if
              unlock vendor
              go to get-next-vennr 
           end-if                 

           move null-vennr             to ve-vennr.
      *    subtract 1                  from null-lienr.

       get-next-vennr-exit.
           exit.
