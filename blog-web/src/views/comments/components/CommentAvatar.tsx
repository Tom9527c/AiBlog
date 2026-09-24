import { useState } from 'react';
import { useMedia } from '../../../components';
import { base } from '../../../services/api';
function AvatarImage({src,name}:{src:string;name:string}) {
 const url=useMedia(src.startsWith('/upload/') ? `${base}${src}` : src);
 const [failed,setFailed]=useState(false);
 return url && !failed ? <img src={url} alt={name} loading="lazy" referrerPolicy="no-referrer" onError={()=>setFailed(true)}/> : <span>{name.slice(0,1)}</span>;
}
export function CommentAvatar({src,name}:{src:string;name:string}) {return <AvatarImage key={src} src={src} name={name}/>;}
