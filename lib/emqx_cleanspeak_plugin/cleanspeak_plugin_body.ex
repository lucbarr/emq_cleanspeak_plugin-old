##--------------------------------------------------------------------
## Copyright (c) 2016-2017 EMQ Enterprise, Inc. (http://emqtt.io)
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##--------------------------------------------------------------------

defmodule EmqxCleanspeakPlugin.Body do

    alias EmqxCleanspeakPlugin.{Filter}
    require Logger

    require Record
    import Record, only: [defrecord: 2, extract: 2]
    defrecord :mqtt_message, extract(:mqtt_message, from: "include/emqttd.hrl")

    def hook_add(a, b, c) do
        :emqttd_hooks.add(a, b, c)
    end
    
    def hook_del(a, b) do
        :emqttd_hooks.delete(a, b)
    end

    def load(env) do
        hook_add(:"message.publish",      &EmqxCleanspeakPlugin.Body.on_message_publish/2,     [env])
    end

    def unload do
        hook_del(:"message.publish",      &EmqxCleanspeakPlugin.Body.on_message_publish/2     )
    end
    
    def on_message_publish(msg, _env) do
        Logger.debug fn -> "on_message_publish: #{msg}" end

        {payload, topic} = {mqtt_message(msg, :payload), mqtt_message(msg, :topic)}
        filtered_message = Filter.filter(payload,topic)
        msg = mqtt_message(msg, payload: filtered_message)
        
        {:ok, msg}
    end
    
    def on_message_delivered(clientId, username, message, _env) do
        IO.inspect(["elixir on_message_delivered", clientId, username, message])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_message_acked(clientId, username, message, _env) do
        IO.inspect(["elixir on_message_acked", clientId, username, message])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_connected(returncode, client, _env) do
        IO.inspect(["elixir on_client_connected", client, returncode, client])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_disconnected(error, client, _env) do
        IO.inspect(["elixir on_client_disconnected", error, client])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_subscribe(clientid, username, topictable, _env) do
        IO.inspect(["elixir on_client_subscribe", clientid, username, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_client_unsubscribe(clientid, username, topictable, _env) do
        IO.inspect(["elixir on_client_unsubscribe", clientid, username, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_session_subscribed(clientid, username, topicitem, _env) do
        IO.inspect(["elixir on_session_subscribed", clientid, username, topicitem])
        
        # add your elixir code here
        
        {:ok, topicitem}
    end
    
    def on_session_unsubscribed(clientid, username, topicitem, _env) do
        IO.inspect(["elixir on_session_unsubscribed", clientid, username, topicitem])
        
        # add your elixir code here
        
        {:ok, topicitem}
    end
end

