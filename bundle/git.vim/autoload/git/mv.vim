""
" @section git-mv, mv
" @parentsection commands
" This commands is to run `git mv` command asynchronously.
" It is to move file to the index. For example, rename current file.
" >
"   :Git mv % new_file.txt
" <

let s:JOB = SpaceVim#api#import('job')

function! git#mv#run(args) abort

  let args = a:args
    if index(a:args, '%') !=# -1
      let index = index(a:args, '%')
      let args[index] = expand('%')
    endif
    let cmd = ['git', 'mv'] + args
    call git#logger#info('git-mv cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#info('git-mv exit data:' . string(a:data))
    if a:data ==# 0
        if exists(':GitGutter')
            GitGutter
        endif
        echo 'done!'
    else
        echo 'failed!'
    endif
endfunction

function! git#rm#complete(ArgLead, CmdLine, CursorPos) abort

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction
